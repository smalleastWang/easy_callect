
import 'dart:convert';
import 'dart:typed_data';
import 'package:chewie/chewie.dart';
import 'package:easy_collect/api/insurance.dart';
import 'package:easy_collect/enums/register.dart';
import 'package:easy_collect/enums/route.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/utils/camera/Config.dart';
import 'package:easy_collect/utils/camera/DetectFFI.dart';
import 'package:easy_collect/widgets/Form/PickerFormField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

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
  final int? registerMedia;
  const PickerImageField({super.key, this.maxNum = 9, this.onChange, required this.controller, this.label, this.uploadApi,  this.mTaskMode = EnumTaskMode.cowFaceRegister, this.registerMedia});

  @override
  State<PickerImageField> createState() => PickerImageFieldState();
}

class PickerImageFieldState extends State<PickerImageField> {

  List<FileInfo> _pickImages = [];

  @override
  initState() {
    iniDet();
    super.initState();
  }

  iniDet() async {
    final detFFIRes = await DetFFI.getInstance().init();
    if(!detFFIRes) {
      EasyLoading.showToast('初始化失败', toastPosition: EasyLoadingToastPosition.top);
    } else {
      EasyLoading.showToast('初始化成功', toastPosition: EasyLoadingToastPosition.top);
    }
  }

  @override
  void dispose() {
    DetFFI.getInstance().clear();
    super.dispose();
  }

  List<Widget> get _pickImagesWidget {
    List<Widget> imageWidget = _pickImages.map((FileInfo file) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          if (file.type == PickFileType.urlImage) Image.network(file.value, width: 80, height: 80, fit: BoxFit.cover)
          else if (file.type == PickFileType.base64Image && file.bytes != null) Image.memory(file.bytes!, width: 80, height: 80, fit: BoxFit.cover)
          else if (file.type == PickFileType.urlVideo) SizedBox(
            width: 120,
            child: AspectRatio(
              aspectRatio: 1,
              child: Chewie(controller: ChewieController(videoPlayerController: VideoPlayerController.networkUrl(Uri.parse(file.value)), autoInitialize: true, allowFullScreen: false, allowMuting: false)),
            ),
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
  void _handlePickImage(ImageSource source) async {
    final picker = ImagePicker();
    List<XFile> pickedFiles = [];
    if (source == ImageSource.camera) {
      if (widget.registerMedia == RegisterMediaEnum.video.value) {
        XFile? pickerVideo = await picker.pickVideo(source: source);
        if (pickerVideo != null) pickedFiles.add(pickerVideo);
      } else if (widget.registerMedia == RegisterMediaEnum.img.value) {
        XFile? pickerImg = await picker.pickImage(source: source);
        if (pickerImg != null) pickedFiles.add(pickerImg);
      } else {
        XFile? cameraFile = await context.push<XFile>(RouteEnum.cameraRegister.path, extra: {'mTaskMode': widget.mTaskMode});
        if (cameraFile != null) pickedFiles.add(cameraFile);
      }
    } else if (source == ImageSource.gallery) {
      if (widget.registerMedia == RegisterMediaEnum.video.value) {
        XFile? pickerVideo = await picker.pickVideo(source: source);
        if (pickerVideo != null) pickedFiles.add(pickerVideo);
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
          fileInfo = FileInfo(value: fileValue, text: pickedFile.name, type: PickFileType.base64Image);
        }
        setState(() {
          _pickImages.add(fileInfo);
        });
      } else {
        String url = await widget.uploadApi!(pickedFile);
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
                children: [
                  ..._pickImagesWidget,
                ],
              ),
            )
          )
        ],
      ),
    );
  }
}