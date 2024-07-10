#ifndef __DETECTION__
#define __DETECTION__

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#if _WIN32
#include <windows.h>
#else
#include <pthread.h>
#include <unistd.h>
#endif

#if _WIN32
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#elif NCNN_YOLOX_FLUTTER_IOS
#define FFI_PLUGIN_EXPORT __attribute__((visibility("default"))) __attribute__((used))
#else
#define FFI_PLUGIN_EXPORT
#endif

#ifdef __cplusplus
extern "C" {
#endif

// A very short-lived native function.
//
// For very short-lived functions, it is fine to call them on the main isolate.
// They will block the Dart execution while running the native function, so
// only do this for native functions which are guaranteed to be short-lived.
FFI_PLUGIN_EXPORT intptr_t sum(intptr_t a, intptr_t b);

// A longer lived native function, which occupies the thread calling it.
//
// Do not call these kind of native functions in the main isolate. They will
// block Dart execution. This will cause dropped frames in Flutter applications.
// Instead, call these native functions on a separate isolate.
FFI_PLUGIN_EXPORT intptr_t sum_long_running(intptr_t a, intptr_t b);

// ncnn

typedef int status_err_t;

#define STATUS_OK        0
#define STATUS_ERROR    -1

// ncnn::Mat::PixelType
enum PixelType {
    PIXEL_RGB = 1,
    PIXEL_BGR = 2,
    PIXEL_GRAY = 3,
    PIXEL_RGBA = 4,
    PIXEL_BGRA = 5,
    PIXEL_YUV = 6,
};

// ncnn::Mat::PixelType
enum DETType {
    FACE_TYPE = 1,
    BODY_TYPE = 2,
};


struct ObjectRect {
    float x;
    float y;
    float w;
    float h;
};

struct Object {
    int label;
    float prob;
    struct ObjectRect rect;
};

struct DetectResult {
    int object_num;
    struct Object *object;
};

FFI_PLUGIN_EXPORT status_err_t modelCreate(const char *model_path, const char *param_path);
FFI_PLUGIN_EXPORT void modelDestroy();

FFI_PLUGIN_EXPORT struct DetectResult *detectResultCreate();
FFI_PLUGIN_EXPORT void detectResultDestroy(struct DetectResult *result);

FFI_PLUGIN_EXPORT status_err_t detectWithPixelsByV5(
        const uint8_t *pixels, enum PixelType pixelType, enum DETType detType,
        int img_w, int img_h, struct DetectResult *result);

#ifdef __cplusplus
}
#endif

#endif