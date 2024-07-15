
import 'dart:convert';
import 'dart:typed_data';
import 'package:easy_collect/enums/route.dart';
import 'package:easy_collect/utils/camera/DetectFFI.dart';
import 'package:easy_collect/widgets/Form/PickerFormField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class FileInfo {
  Uint8List? bytes;
  String value;
  String? text;
  FileInfo({this.text, required this.value, this.bytes});
}
typedef UploadApi = Future<String> Function(XFile flie);

class PickerImageField extends StatefulWidget {
  final UploadApi? uploadApi;
  final int maxNum;
  final String? label;
  final bool multiple;
  final Function(List<FileInfo> files)? onChange;
  final PickerImageController controller;
  const PickerImageField({super.key, this.maxNum = 9, this.onChange, required this.controller, this.multiple = false, this.label, this.uploadApi});

  @override
  State<PickerImageField> createState() => _PickerImageFieldState();
}

class _PickerImageFieldState extends State<PickerImageField> {

  final List<FileInfo> _pickImages = [];

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
    List<Image> imageWidget = _pickImages.map((FileInfo file) {
      if (file.bytes == null) {
        return Image.network(file.value);
      }
      return Image.memory(file.bytes!, width: 80, height: 80);
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
  void _handlePickImage([ImageSource? source]) async {
    final picker = ImagePicker();
    List<XFile> pickedFiles = [];
    if (widget.multiple || source == null) {
      pickedFiles.addAll(await picker.pickMultiImage());
    } else {
      
      if (source == ImageSource.camera) {
        final barcode = await context.push(RouteEnum.cameraRegister.path);
        print(barcode);
        return;
      }
      XFile? pickfile = await picker.pickImage(source: source);
      if (pickfile != null) pickedFiles.add(pickfile);
    }

    for (XFile pickedFile in pickedFiles) {
      if (widget.uploadApi == null) {
        final bytes = await pickedFile.readAsBytes();
        final FileInfo fileInfo = FileInfo(value: base64Encode(bytes), text: pickedFile.name, bytes: bytes);
        setState(() {
          _pickImages.add(fileInfo);
        });
      } else {
        // String url = await RegisterApi.uavUpload(pickedFile);
        String url = await widget.uploadApi!(pickedFile);
        setState(() {
          _pickImages.add(FileInfo(value: url, text: pickedFile.name));
        });
      }
    }
    if (widget.onChange is Function) {
      widget.onChange!(_pickImages);
    }
    widget.controller.value = _pickImages;
  }

  _handleAction() {
    if (widget.multiple) {
      _handlePickImage();
      return;
    }
    showCupertinoModalPopup<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () => context.pop(ImageSource.gallery),
              child: const Text("相册")
            ),
            CupertinoActionSheetAction(
              onPressed: () => context.pop(ImageSource.camera),
              child: const Text("拍照")
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => context.pop(),
            child: const Text("取消")
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