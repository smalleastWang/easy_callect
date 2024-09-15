
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:chewie/chewie.dart';
import 'package:collection/collection.dart';
import 'package:easy_collect/api/insurance.dart';
import 'package:easy_collect/enums/register.dart';
import 'package:easy_collect/enums/route.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/utils/camera/CameraxUtils.dart';
import 'package:easy_collect/utils/camera/Config.dart';
import 'package:easy_collect/utils/camera/DetectFFI.dart';
import 'package:easy_collect/utils/dialog.dart';
import 'package:easy_collect/widgets/Form/PickerFormField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';

import 'package:image/image.dart' as img;
import 'package:photo_view/photo_view_gallery.dart';

enum PickFileType {
  base64Image,
  base64Video,
  urlImage,
  urlVideo,
}

class FileInfo {
  Uint8List? bytes;
  String value;
  String? text;
  PickFileType type;

  FileInfo({this.text, required this.value, this.bytes, required this.type});
}
typedef UploadApi = Future<String> Function(XFile flie);

class PickerImageField extends StatefulWidget {
  final UploadApi? uploadApi;
  final int maxNum;
  final String? label;
  final Function(List<FileInfo> files)? onChange;
  final PickerImageController controller;
  final EnumTaskMode mTaskMode;
  final int registerMedia;
  const PickerImageField({super.key, this.maxNum = 9, this.onChange, required this.controller, this.label, this.uploadApi,  this.mTaskMode = EnumTaskMode.cowFaceRegister, required this.registerMedia});

  @override
  State<PickerImageField> createState() => PickerImageFieldState();
}

class PickerImageFieldState extends State<PickerImageField> {

  List<FileInfo> _pickImages = [];
  String previewTitle = '';

  @override
  void dispose() {
    DetFFI.getInstance().clear();
    super.dispose();
  }

  Widget? _imgItem(FileInfo file) {
    if (file.type == PickFileType.urlImage) {
      return Image.network(file.value, fit: BoxFit.cover);
    } else if (file.type == PickFileType.base64Image && file.bytes != null) {
      return Image.memory(file.bytes!, fit: BoxFit.cover);
    } else if (file.type == PickFileType.urlVideo) {
      return SizedBox(
        width: double.infinity,
        child: AspectRatio(
          aspectRatio: 1,
          child: Chewie(controller: ChewieController(videoPlayerController: VideoPlayerController.networkUrl(Uri.parse(file.value)), autoInitialize: true, allowFullScreen: false, allowMuting: false)),
        ),
      );
    }
    return null;
  }
  bool getIsPreview(FileInfo file) {
    return [PickFileType.urlImage, PickFileType.base64Image].contains(file.type);
  }
  ImageProvider getImageProvider(FileInfo file) {
    if (file.type == PickFileType.urlImage) {
      return NetworkImage(file.value);
    } else  {
      return MemoryImage(file.bytes!);
    }
  }

  List<Widget> get _pickImagesWidget {
    

    List<Widget> imageWidget = _pickImages.map((FileInfo file) {
      
      return SizedBox(
        width: 80,
        height: 80,
        child: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            InkWell(
              onTap: () {
                bool isPreview  = getIsPreview(file);
                if (!isPreview) return;
                
                List<FileInfo> imgs = _pickImages.where(getIsPreview).toList();
                
                showMyModalBottomSheet(
                  context: context,
                  title: '图片预览',
                  contentBuilder: (context) {
                    return PhotoViewGallery.builder(
                      scrollPhysics: const BouncingScrollPhysics(),
                      builder: (BuildContext context, int index) {
                        return PhotoViewGalleryPageOptions(
                          imageProvider: getImageProvider(imgs[index]),
                        );
                      },
                      itemCount: imgs.length,
                      loadingBuilder: (context, event) => Center(
                        child: SizedBox(
                          width: 20.0,
                          height: 20.0,
                          child: CircularProgressIndicator(
                            value: event == null
                                ? 0
                                : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                          ),
                        ),
                      ),
                      pageController: PageController(initialPage: imgs.indexWhere((i) => i.text == file.text)),
                      backgroundDecoration: BoxDecoration(color: Colors.black.withOpacity(0.01)),
                    );
                  },
                );
              },
              child:  _imgItem(file)
            ),
            Positioned(
              top: -4,
              right: -4,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _pickImages.remove(file);
                  });
                },
                behavior: HitTestBehavior.translucent,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(width: 1, color: Colors.white)
                  ),
                  child: SvgPicture.asset('assets/icon/common/close.svg', width: 10,color: Colors.white),
                ),
              )
            )
          ],
        )
      );
    }).toList();
    List<Widget> result = [...imageWidget];
    if (result.length < widget.maxNum) {
      result.add(GestureDetector(
        onTap: _handleAction,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(width: 1.5, color: Colors.grey)
          ),
          child: const Icon(Icons.add, size: 28),
        ),
      ));
    }
    return result;
  }
  // 选中或拍照完成处理
  void _handlePickImage(ImageSource source) async {
    final picker = ImagePicker();
    List<XFile> pickedFiles = [];
    // 拍摄
    if (source == ImageSource.camera) {
      // 拍视频 - 不校验
      if (widget.registerMedia == RegisterMediaEnum.video.value) {
        XFile? pickerVideo = await picker.pickVideo(source: source);
        if (pickerVideo != null) pickedFiles.add(pickerVideo);
      // 拍照片 - 注册方式为图片 - 不校验
      } else if (widget.registerMedia == RegisterMediaEnum.img.value) {
        XFile? pickerImg = await picker.pickImage(source: source);
        if (pickerImg != null) pickedFiles.add(pickerImg);
      // 校验-拍照
      } else {
        List<XFile>? cameraFile = await context.push(RouteEnum.cameraRegister.path, extra: {'mTaskMode': widget.mTaskMode});
        if (cameraFile != null) pickedFiles.addAll(cameraFile);
      }
    // 选取照片或者视频
    } else if (source == ImageSource.gallery) {
      if (widget.registerMedia == RegisterMediaEnum.video.value) {
        XFile? pickerVideo = await picker.pickVideo(source: source);
        if (pickerVideo != null) pickedFiles.add(pickerVideo);
      // 选照片 - 牛脸牛背 - 校验
      } else if (widget.registerMedia == RegisterMediaEnum.face.value || widget.registerMedia == RegisterMediaEnum.back.value) {
        List<XFile> pickfiles = await picker.pickMultiImage(limit: 9, maxWidth: 1000);
        EasyLoading.show(status: '图片校验中');
        try {
          for (var file in pickfiles) {
            img.Image? i = await img.decodeImageFile(file.path);
            List<DetObject> checkResult = await DetFFI.getInstance().detectFaceImage(i!);
            if (checkResult.isEmpty) {
              EasyLoading.showToast('图片<${file.name}>未检测到目标');
              continue;
            }
            DetObject detObject = checkResult[0];
            Rect rect = DetectionObject(prob: detObject.prob, rect: detObject.rect).rect;
            img.Image cropImg = img.copyCrop(i, x: rect.left.toInt(), y: rect.top.toInt(), width: rect.width.toInt(), height: rect.height.toInt());
            Uint8List cropBytes = Uint8List.fromList(img.encodePng(cropImg));

            File newImg = File(file.path);
            newImg.writeAsBytesSync(cropBytes);
            XFile cropImgFile  = XFile(file.path, bytes: cropBytes);
            
            pickedFiles.add(cropImgFile);
          }
        } finally {
          EasyLoading.dismiss();
        }
      // 选照片 - 注册方式为图片 - 不校验
      } else {
        XFile? pickfile = await picker.pickImage(source: source);
        if (pickfile != null) pickedFiles.add(pickfile);
      }
    }

    for (XFile pickedFile in pickedFiles) {
      if (widget.uploadApi == null) {
        Uint8List? bytes;
        String fileValue = '';
        FileInfo fileInfo;
        // 视频
        if (widget.registerMedia == RegisterMediaEnum.video.value) {
          UploadVideoVo data = await RegisterApi.videoUpload(pickedFile);
          fileValue = data.url;
          fileInfo = FileInfo(value: fileValue, text: pickedFile.name, type: PickFileType.urlVideo);
        } else {
          bytes = await pickedFile.readAsBytes();
          fileValue = base64Encode(bytes);
          fileInfo = FileInfo(value: fileValue, text: pickedFile.name, type: PickFileType.base64Image, bytes: bytes);
        }
        if (_pickImages.length >= widget.maxNum) {
          EasyLoading.showToast('最多上传[${widget.maxNum}]个图片或视频');
          break;
        }
        setState(() {
          _pickImages.add(fileInfo);
        });
        
      } else {
        String url = await widget.uploadApi!(pickedFile);
        if (_pickImages.length >= widget.maxNum) {
          EasyLoading.showToast('最多上传[${widget.maxNum}]个图片或视频');
          break;
        }
        setState(() {
          _pickImages.add(FileInfo(value: url, text: pickedFile.name, type: PickFileType.urlImage));
        });
      }
    }
    if (widget.onChange is Function) {
      widget.onChange!(_pickImages);
    }
    widget.controller.value = _pickImages;
  }

  clearPickImages() {
    setState(() {
      _pickImages = [];
    });
  }

  _handleAction() {
    showCupertinoModalPopup<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () => context.pop(ImageSource.gallery),
              child: const Text('相册')
            ),
            if (widget.registerMedia != RegisterMediaEnum.drones.value) CupertinoActionSheetAction(
              onPressed: () => context.pop(ImageSource.camera),
              child: Text(widget.registerMedia == RegisterMediaEnum.video.value ? '拍视频' : '拍照')
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => context.pop(),
            child: const Text('取消')
          ),
        );
      }
    ).then((source) {
      if (source != null) {
        _handlePickImage(source);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          widget.label != null ? Container(
            alignment: Alignment.centerLeft,
            child: Text(widget.label!, style: const TextStyle(fontSize: 16)),
          ) : const SizedBox.shrink(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 10),
            child: SingleChildScrollView(
              child: Wrap(  
                spacing: 13,
                runSpacing: 8,
                alignment: WrapAlignment.start,
                children: _pickImagesWidget,
              ),
            )
          )
        ],
      ),
    );
  }
}