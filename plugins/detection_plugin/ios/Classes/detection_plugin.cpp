#include "detection_plugin.h"


// ncnn
#if defined(NCNN_YOLOX_FLUTTER_IOS)
#include "ncnn/ncnn/layer.h"
#include "ncnn/ncnn/net.h"
#include "ncnn/ncnn/simpleocv.h"
#else
#include "layer.h"
#include "net.h"
#include "benchmark.h"
#include "simpleocv.h"
#endif

#include <float.h>
#include <stdio.h>
#include <vector>


using namespace std;


static ncnn::UnlockedPoolAllocator g_blob_pool_allocator;
static ncnn::PoolAllocator g_workspace_pool_allocator;

static ncnn::Net model_face;

static ncnn::Net model_body;

// A very short-lived native function.
//
// For very short-lived functions, it is fine to call them on the main isolate.
// They will block the Dart execution while running the native function, so
// only do this for native functions which are guaranteed to be short-lived.
FFI_PLUGIN_EXPORT intptr_t sum(intptr_t a, intptr_t b) { return a + b; }

// A longer-lived native function, which occupies the thread calling it.
//
// Do not call these kind of native functions in the main isolate. They will
// block Dart execution. This will cause dropped frames in Flutter applications.
// Instead, call these native functions on a separate isolate.
FFI_PLUGIN_EXPORT intptr_t sum_long_running(intptr_t a, intptr_t b) {
    // Simulate work.
#if _WIN32
    Sleep(5000);
#else
    usleep(5000 * 1000);
#endif
    return a + b;
}

// internal
//  https://github.com/Tencent/ncnn/blob/master/examples/yolox.cpp

#define NMS_THRESH  0.45 // nms threshold
#define CONF_THRESH 0.25 // threshold of bounding box prob
#define TARGET_SIZE 640  // target image size after resize, might use 416 for small model


// YOLOX use the same focus in yolov5
class YoloV5Focus : public ncnn::Layer {
    public:
    YoloV5Focus() {
        one_blob_only = true;
    }

    virtual int forward(const ncnn::Mat& bottom_blob, ncnn::Mat& top_blob, const ncnn::Option& opt) const {
        int w = bottom_blob.w;
        int h = bottom_blob.h;
        int channels = bottom_blob.c;

        int outw = w / 2;
        int outh = h / 2;
        int outc = channels * 4;

        top_blob.create(outw, outh, outc, 4u, 1, opt.blob_allocator);
        if (top_blob.empty())
            return -100;

        #pragma omp parallel for num_threads(opt.num_threads)
        for (int p = 0; p < outc; p++) {
            const float* ptr = bottom_blob.channel(p % channels).row((p / channels) % 2) + ((p / channels) / 2);
            float* outptr = top_blob.channel(p);

            for (int i = 0; i < outh; i++) {
                for (int j = 0; j < outw; j++) {
                    *outptr = *ptr;

                    outptr += 1;
                    ptr += 2;
                }

                ptr += w;
            }
        }

        return 0;
    }
};

DEFINE_LAYER_CREATOR(YoloV5Focus)

// external

FFI_PLUGIN_EXPORT status_err_t modelCreate(const char *model_path, const char *param_path) {
    
    model_face.opt.use_vulkan_compute = false;
    // net.opt.use_bf16_storage = true;
    model_face.opt.lightmode = true;
    model_face.opt.num_threads = 4;

    // Focus in yolov5
    model_face.register_custom_layer("YoloV5Focus", YoloV5Focus_layer_creator);

    if (model_face.load_param(param_path) != 0) return STATUS_ERROR;
    if (model_face.load_model(model_path) != 0) return STATUS_ERROR;

    return STATUS_OK;
}

FFI_PLUGIN_EXPORT void modelDestroy() {
    model_face.clear();
    model_body.clear();
}

FFI_PLUGIN_EXPORT struct DetectResult *detectResultCreate() {
    auto result = (DetectResult *) malloc(sizeof(struct DetectResult));
    result->object_num = 0;
    result->object = NULL;
    return result;
}

FFI_PLUGIN_EXPORT void detectResultDestroy(struct DetectResult *result) {
    if (result == NULL) return;

    if (result->object != NULL) {
        free(result->object);
        result->object = NULL;
    }

    free(result);
    result = NULL;
}


static float intersection_area(const Object& a, const Object& b)
{
    if (a.rect.x > b.rect.x + b.rect.w || a.rect.x + a.rect.w < b.rect.x || a.rect.y > b.rect.y + b.rect.h || a.rect.y + a.rect.h < b.rect.y)
    {
        // no intersection
        return 0.f;
    }

    float inter_width = std::min(a.rect.x + a.rect.w, b.rect.x + b.rect.w) - std::max(a.rect.x, b.rect.x);
    float inter_height = std::min(a.rect.y + a.rect.h, b.rect.y + b.rect.h) - std::max(a.rect.y, b.rect.y);

    return inter_width * inter_height;
}

static void qsort_descent_inplace(std::vector<::Object>& faceobjects, int left, int right)
{
    int i = left;
    int j = right;
    float p = faceobjects[(left + right) / 2].prob;

    while (i <= j)
    {
        while (faceobjects[i].prob > p)
            i++;

        while (faceobjects[j].prob < p)
            j--;

        if (i <= j)
        {
            // swap
            std::swap(faceobjects[i], faceobjects[j]);

            i++;
            j--;
        }
    }

    #pragma omp parallel sections
    {
        #pragma omp section
        {
            if (left < j) qsort_descent_inplace(faceobjects, left, j);
        }
        #pragma omp section
        {
            if (i < right) qsort_descent_inplace(faceobjects, i, right);
        }
    }
}

static void qsort_descent_inplace(std::vector<::Object>& faceobjects)
{
    if (faceobjects.empty())
    return;

    qsort_descent_inplace(faceobjects, 0, faceobjects.size() - 1);
}

static void nms_sorted_bboxes(const std::vector<::Object>& faceobjects, std::vector<int>& picked, float nms_threshold)
{
    picked.clear();

    const int n = faceobjects.size();

    std::vector<float> areas(n);
    for (int i = 0; i < n; i++)
    {
        areas[i] = faceobjects[i].rect.w * faceobjects[i].rect.h;
    }

    for (int i = 0; i < n; i++)
    {
        const ::Object& a = faceobjects[i];

        int keep = 1;
        for (int j = 0; j < (int)picked.size(); j++)
        {
            const ::Object& b = faceobjects[picked[j]];

            // intersection over union
            float inter_area = intersection_area(a, b);
            float union_area = areas[i] + areas[picked[j]] - inter_area;
            // float IoU = inter_area / union_area
            if (inter_area / union_area > nms_threshold)
            keep = 0;
        }

        if (keep)
        picked.push_back(i);
    }
}



static float sigmoid(float x)
{
    return static_cast<float>(1.f / (1.f + exp(-x)));
}

static void generate_proposals(const ncnn::Mat& anchors, int stride, const ncnn::Mat& in_pad, const ncnn::Mat& feat_blob, float prob_threshold, std::vector<::Object>& objects)
{
    const int num_grid = feat_blob.h;

    int num_grid_x;
    int num_grid_y;
    if (in_pad.w > in_pad.h)
    {
        num_grid_x = in_pad.w / stride;
        num_grid_y = num_grid / num_grid_x;
    }
    else
    {
        num_grid_y = in_pad.h / stride;
        num_grid_x = num_grid / num_grid_y;
    }

    const int num_class = feat_blob.w - 5;

    const int num_anchors = anchors.w / 2;

    for (int q = 0; q < num_anchors; q++)
    {
        const float anchor_w = anchors[q * 2];
        const float anchor_h = anchors[q * 2 + 1];

        const ncnn::Mat feat = feat_blob.channel(q);

        for (int i = 0; i < num_grid_y; i++)
        {
            for (int j = 0; j < num_grid_x; j++)
            {
                const float* featptr = feat.row(i * num_grid_x + j);

                // find class index with max class score
                int class_index = 0;
                float class_score = -FLT_MAX;
                for (int k = 0; k < num_class; k++)
                {
                    float score = featptr[5 + k];
                    if (score > class_score)
                    {
                        class_index = k;
                        class_score = score;
                    }
                }

                float box_score = featptr[4];

                float confidence = sigmoid(box_score) * sigmoid(class_score);

                if (confidence >= prob_threshold)
                {
                // yolov5/models/yolo.py Detect forward
                // y = x[i].sigmoid()
                // y[..., 0:2] = (y[..., 0:2] * 2. - 0.5 + self.grid[i].to(x[i].device)) * self.stride[i]  # xy
                // y[..., 2:4] = (y[..., 2:4] * 2) ** 2 * self.anchor_grid[i]  # wh

                float dx = sigmoid(featptr[0]);
                float dy = sigmoid(featptr[1]);
                float dw = sigmoid(featptr[2]);
                float dh = sigmoid(featptr[3]);

                float pb_cx = (dx * 2.f - 0.5f + j) * stride;
                float pb_cy = (dy * 2.f - 0.5f + i) * stride;

                float pb_w = pow(dw * 2.f, 2) * anchor_w;
                float pb_h = pow(dh * 2.f, 2) * anchor_h;

                float x0 = pb_cx - pb_w * 0.5f;
                float y0 = pb_cy - pb_h * 0.5f;
                float x1 = pb_cx + pb_w * 0.5f;
                float y1 = pb_cy + pb_h * 0.5f;

                ::Object obj;
                obj.rect.x = x0;
                obj.rect.y = y0;
                obj.rect.h = y1-y0;
                obj.rect.w = x1-x0;

                obj.label = class_index;
                obj.prob = confidence;

                objects.push_back(obj);
                }
            }
        }
    }
}

static void yuv2bgr2(unsigned char * yuv_img, unsigned char *rgb_img, int width, int height)
{

    unsigned char * ydata = yuv_img;
    unsigned char *uvdata = ydata + width * height;
    int indexY, indexU, indexV;
    unsigned char Y, U, V;
    int B, G, R;

    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j+=2)
        {
            indexY = i * width + j;
            Y = ydata[indexY];

            indexU = i / 2 * width + j;
            indexV = indexU + 1;
            U = uvdata[indexU];
            V = uvdata[indexV];
            /*first*/
            //nv21
            R = (int)(Y * 4096 + 5765 * (U - 128));
            G = (int)(Y * 4096 - 1415 * (V - 128) - 2936 * (U - 128));
            B = (int)(Y * 4096 + 7286 * (V - 128));
            //nv12
            //R = (unsigned char)(Y + 1.4075 * (V - 128));
            //G = (unsigned char)(Y - 0.3455 * (U - 128) - 0.7169 * (V - 128));
            //B = (unsigned char)(Y + 1.779 * (U - 128));

            rgb_img[indexY * 3 + 0] = B >> 12;// clamp_g(B >> 12, 0, 255);
            rgb_img[indexY * 3 + 1] = G >> 12;// clamp_g(G >> 12, 0, 255);
            rgb_img[indexY * 3 + 2] = R >> 12;//clamp_g(R >> 12, 0, 255);
            /*second*/
            indexY = indexY + 1;
            Y = ydata[indexY];
            //nv21
            R = (int)(Y * 4096 + 5765 * (U - 128));
            G = (int)(Y * 4096 - 1415 * (V - 128) - 2936 * (U - 128));
            B = (int)(Y * 4096 + 7286 * (V - 128));
            rgb_img[indexY * 3 + 0] = B >> 12;// clamp_g(B >> 12, 0, 255);
            rgb_img[indexY * 3 + 1] = G >> 12;// clamp_g(G >> 12, 0, 255);
            rgb_img[indexY * 3 + 2] = R >> 12;//clamp_g(R >> 12, 0, 255);
        }
    }
}

static inline void rotateRGB90(unsigned char *src, unsigned char *dst, int width, int height, int bpp) {
        int dstIndex = 0;
        int srcIndex = 0;
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                //(y, x) -> (x, height - y - 1)
                //y * width + x, -> x* height + height - y - 1
                dstIndex = (x * height + height - y - 1) * bpp;
                for (int i = 0; i < bpp; i++) {
                    dst[dstIndex + i] = src[srcIndex++];
                }
            }
        }
    }

static inline void rotateRGB90(int *src, int *dst, int width, int height) {
    int dstIndex = 0;
    int srcIndex = 0;
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            //(y, x) -> (x, height - y - 1)
            //y * width + x, -> x* height + height - y - 1
            dstIndex = x * height + height - y - 1;
            dst[dstIndex] = src[srcIndex++];
        }
    }
}

static inline void rotateRGB180(unsigned char *src, unsigned char *dst, int width, int height, int bpp) {
    int dstIndex = 0;
    int srcIndex = 0;
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            //(y, x) -> (height - y - 1, width - x - 1)
            //y * width + x, -> (height - y - 1) * width + width - x - 1
            dstIndex = ((height - y - 1) * width + width - x - 1) * bpp;
            for (int i = 0; i < bpp; i++) {
                dst[dstIndex + i] = src[srcIndex++];
            }
        }
    }
}

static inline void rotateRGB180(int *src, int *dst, int width, int height) {
    int dstIndex = 0;
    int srcIndex = 0;
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            //(y, x) -> (height - y - 1, width - x - 1)
            //y * width + x, -> (height - y - 1) * width + width - x - 1
            dstIndex = (height - y - 1) * width + width - x - 1;
            dst[dstIndex] = src[srcIndex++];
        }
    }
}

static inline void rotateRGB270(unsigned char *src, unsigned char *dst, int width, int height, int bpp) {
    int dstIndex = 0;
    int srcIndex = 0;
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            //(y, x) -> (width - x - 1, y)
            //y * width + x, -> (width - x - 1) * height + y
            dstIndex = ((width - x - 1) * height + y) * bpp;
            for (int i = 0; i < bpp; i++) {
                dst[dstIndex + i] = src[srcIndex++];
            }
        }
    }
}

static inline void rotateRGB270(int *src, int *dst, int width, int height) {
    int dstIndex = 0;
    int srcIndex = 0;
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            //(y, x) -> (width - x - 1, y)
            //y * width + x, -> (width - x - 1) * height + y
            dstIndex = (width - x - 1) * height + y;
            dst[dstIndex] = src[srcIndex++];
        }
    }
}

void rotateRGB(unsigned char *src, unsigned char *dst, int width, int height, float degree) {
    if (degree == 90.0f) {
        rotateRGB90(src, dst, width, height, 3);
    } else if (degree == 180.0f) {
        rotateRGB180(src, dst, width, height, 3);
    } else if (degree == 270.0f) {
        rotateRGB270(src, dst, width, height, 3);
    } else {
        return;
    }
}

void bgra_to_bgr(unsigned char* bgra, unsigned char* bgr, int size) {
    for (int i = 0; i < size; ++i) {
        // BGRA到BGR的转换
        bgr[i * 3]     = bgra[i * 4];     // B
        bgr[i * 3 + 1] = bgra[i * 4 + 1]; // G
        bgr[i * 3 + 2] = bgra[i * 4 + 2]; // R
    }
}


FFI_PLUGIN_EXPORT status_err_t detectWithPixelsByV5(
        const uint8_t *pixels, enum PixelType pixelType, enum DETType detType,
        int img_w, int img_h, struct DetectResult *result){
    // ncnn from bitmap
    const int target_size = 640;

    // letterbox pad to multiple of 32
    int w = img_w;
    int h = img_h;
    float scale = 1.f;
    if (w > h)
    {
        scale = (float)target_size / w;
        w = target_size;
        h = h * scale;
    }
    else
    {
        scale = (float)target_size / h;
        h = target_size;
        w = w * scale;
    }
    ncnn::Mat in;
    if(pixelType == PixelType::PIXEL_YUV){
        unsigned char* rgb_img = (unsigned char*)malloc(img_h * img_w * 3 * sizeof(unsigned char));
        unsigned char* rotate_img = (unsigned char*)malloc(img_h * img_w * 3 * sizeof(unsigned char));
        yuv2bgr2((unsigned char*)pixels, rgb_img, img_w, img_h);
        rotateRGB(rgb_img, rotate_img, img_w, img_h, 90.0f);
        in = ncnn::Mat::from_pixels_resize(rotate_img, PixelType::PIXEL_BGR, img_h, img_w, h, w);
        free(rgb_img);
        free(rotate_img);
        swap(img_w, img_h);
        swap(h, w);
    }
    else if(pixelType == PixelType::PIXEL_BGR){
        in = ncnn::Mat::from_pixels_resize(pixels, PixelType::PIXEL_BGR, img_w, img_h, w, h);
    }
    else if(pixelType == PixelType::PIXEL_BGRA){
        int _size = img_h * img_w * 3 * sizeof(unsigned char);
        unsigned char* bgr_img = (unsigned char*)malloc(_size);
        bgra_to_bgr((unsigned char*)pixels, bgr_img, _size);
        in = ncnn::Mat::from_pixels_resize(bgr_img, PixelType::PIXEL_BGR, img_h, img_w, h, w);
        free(bgr_img);
    }
    // pad to target_size rectangle
    // yolov5/utils/datasets.py letterbox
    int wpad = (w + 31) / 32 * 32 - w;
    int hpad = (h + 31) / 32 * 32 - h;
    ncnn::Mat in_pad;
    ncnn::copy_make_border(in, in_pad, hpad / 2, hpad - hpad / 2, wpad / 2, wpad - wpad / 2, ncnn::BORDER_CONSTANT, 114.f);

    // yolov5
    std::vector<::Object> objects;
    {
        const float prob_threshold = 0.25f;
        const float nms_threshold = 0.45f;

        const float norm_vals[3] = {1 / 255.f, 1 / 255.f, 1 / 255.f};
        in_pad.substract_mean_normalize(0, norm_vals);

        ncnn::Extractor ex = model_face.create_extractor();

        ex.input("images", in_pad);

        std::vector<::Object> proposals;

        // anchor setting from yolov5/models/yolov5s.yaml

        // stride 8
        {
            ncnn::Mat out;
            ex.extract("output", out);

            ncnn::Mat anchors(6);
            anchors[0] = 10.f;
            anchors[1] = 13.f;
            anchors[2] = 16.f;
            anchors[3] = 30.f;
            anchors[4] = 33.f;
            anchors[5] = 23.f;

            std::vector<::Object> objects8;
            generate_proposals(anchors, 8, in_pad, out, prob_threshold, objects8);

            proposals.insert(proposals.end(), objects8.begin(), objects8.end());
        }

        // stride 16
        {
            ncnn::Mat out;
            ex.extract("375", out);

            ncnn::Mat anchors(6);
            anchors[0] = 30.f;
            anchors[1] = 61.f;
            anchors[2] = 62.f;
            anchors[3] = 45.f;
            anchors[4] = 59.f;
            anchors[5] = 119.f;

            std::vector<::Object> objects16;
            generate_proposals(anchors, 16, in_pad, out, prob_threshold, objects16);

            proposals.insert(proposals.end(), objects16.begin(), objects16.end());
        }

        // stride 32
        {
            ncnn::Mat out;
            ex.extract("400", out);

            ncnn::Mat anchors(6);
            anchors[0] = 116.f;
            anchors[1] = 90.f;
            anchors[2] = 156.f;
            anchors[3] = 198.f;
            anchors[4] = 373.f;
            anchors[5] = 326.f;

            std::vector<::Object> objects32;
            generate_proposals(anchors, 32, in_pad, out, prob_threshold, objects32);

            proposals.insert(proposals.end(), objects32.begin(), objects32.end());
        }
        // sort all proposals by score from highest to lowest
        qsort_descent_inplace(proposals);

        // apply nms with nms_threshold
        std::vector<int> picked;
        nms_sorted_bboxes(proposals, picked, nms_threshold);

        int count = picked.size();

        //非中心抑制
        int cx = img_w / 2;
        int cy = img_h / 2;

        int band_Width = cx/2;
        int band_Height = cy/2;

        int x_left = cx  - band_Width;
        int x_right = cx + band_Width;
        int y_top = cy - band_Height;
        int y_bottom = cy + band_Height;
        for (int i = 0; i < count; i++)
        {
            // adjust offset to original unpadded
            float x0 = (proposals[picked[i]].rect.x - (wpad / 2)) / scale;
            float y0 = (proposals[picked[i]].rect.y - (hpad / 2)) / scale;
            float x1 = (proposals[picked[i]].rect.x + proposals[picked[i]].rect.w - (wpad / 2)) / scale;
            float y1 = (proposals[picked[i]].rect.y + proposals[picked[i]].rect.h - (hpad / 2)) / scale;

            // clip
            x0 = std::max(std::min(x0, (float)(img_w - 1)), 0.f);
            y0 = std::max(std::min(y0, (float)(img_h - 1)), 0.f);
            x1 = std::max(std::min(x1, (float)(img_w - 1)), 0.f);
            y1 = std::max(std::min(y1, (float)(img_h - 1)), 0.f);

            proposals[picked[i]].rect.x = x0;
            proposals[picked[i]].rect.y = y0;
            proposals[picked[i]].rect.w = x1 - x0;
            proposals[picked[i]].rect.h = y1 - y0;

            int tx = (x1 - x0) / 2;
            int ty = (y1 - y0) / 2;
            if (x0+tx < x_left || x0+tx > x_right) {
                continue;
            }

            if (y0+ty < y_top || y0+ty > y_bottom) {
                continue;
            }
            objects.push_back(proposals[picked[i]]);
        }
    }

    using Obj = struct ::Object;
    int n_size = objects.size();
    Obj *obj = (Obj *) malloc(n_size * sizeof(Obj));

    for (int i = 0; i < n_size; i++) {
        auto object = objects[i];
        auto obj_i = obj + i;
        obj_i->label = object.label;
        obj_i->prob = object.prob;
        obj_i->rect.x = object.rect.x;
        obj_i->rect.y = object.rect.y;
        obj_i->rect.w = object.rect.w;
        obj_i->rect.h = object.rect.h;
    }
    result->object_num = n_size;
    result->object = obj;

    return STATUS_OK;
}

