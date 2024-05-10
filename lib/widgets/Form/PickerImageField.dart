
import 'dart:convert';
import 'dart:typed_data';

import 'package:easy_collect/enums/route.dart';
import 'package:easy_collect/widgets/Form/PickerFormField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class FileInfo {
  Uint8List bytes;
  String value;
  String? text;
  FileInfo({this.text, required this.value, required this.bytes});
}

class PickerImageField extends StatefulWidget {
  final int maxNum;
  final bool multiple;
  final Function(List<FileInfo> files)? onChange;
  final PickerImageController controller;
  const PickerImageField({super.key, this.maxNum = 9, this.onChange, required this.controller, this.multiple = false});

  @override
  State<PickerImageField> createState() => _PickerImageFieldState();
}

class _PickerImageFieldState extends State<PickerImageField> {

  final List<FileInfo> _pickImages = [];

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> get _pickImagesWidget {
    List<Image> imageWidget = _pickImages.map((FileInfo file) {
      return Image.memory(file.bytes, width: 80, height: 80);
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
      XFile? pickfike = await picker.pickImage(source: source);
      if (pickfike != null) pickedFiles.add(pickfike);
    }

    for (XFile pickedFile in pickedFiles) {
      final bytes = await pickedFile.readAsBytes();
      final FileInfo fileInfo = FileInfo(value: base64Encode(bytes), text: pickedFile.name, bytes: bytes);
      setState(() {
        _pickImages.add(fileInfo);
      });
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 10),
      child: Expanded(
        child: Wrap(
          spacing: 13,
          runSpacing: 8,
          alignment: WrapAlignment.start,
          children: [
            ..._pickImagesWidget,
          ],
        ),
      ),
    );
  }
}