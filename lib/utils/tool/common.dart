import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;

List<T> listMapToModel<T>(List<dynamic> listMap, Function jsonF) {
  List<T> list = [];
  for (var item in listMap) {
    list.add(jsonF(item));
  }
  return list;
}

InputDecoration getInputDecoration({String? labelText, String? hintText}) {
  return InputDecoration(
    labelText: labelText,
    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    border: const OutlineInputBorder(),
    hintText: hintText,
  );
}

String getFileExtension(String fileName) {
  // 从文件名最后一个点（.）开始分割字符串
  // 如果文件名中没有点，则split方法将返回一个只包含原文件名的列表
  // 因此，我们检查列表的长度是否大于1，以确保存在扩展名
  List<String> parts = fileName.split('.');
  if (parts.length > 1) {
    // 返回最后一个部分作为扩展名
    // 注意：如果文件名以点结束（例如"file."），这将返回空字符串
    return parts.last.toLowerCase(); // 可以选择转换为小写以统一格式
  } else {
    // 如果没有找到扩展名，返回null或空字符串，取决于你的需求
    return '';
  }
}

String getMd5FileName(String fileName) {
  List<String> parts = fileName.split('.');
  if (parts.length > 1) {
    var ext = path.extension(fileName);
    String nameStr = path.basenameWithoutExtension(fileName);
    String md5Name = md5.convert(utf8.encode(nameStr)).toString();
    return '$md5Name$ext';
  } else {
    return md5.convert(utf8.encode(fileName)).toString();
  }
}

String getRandomString(int length) {
  const characters =
      '+-*=?AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
  Random random = Random();
  return String.fromCharCodes(Iterable.generate(
      length, (_) => characters.codeUnitAt(random.nextInt(characters.length))));
}

Uint8List cropImage(
  img.Image image, {
  required int cropX,
  required int cropY,
  required int cropWidth,
  required int cropHeight,
}) {
// 假设你已经有了一个Uint8List表示的原始图像数据
// 和图像的宽度、高度
  int originalWidth = image.width;
  int originalHeight = image.height;
  Uint8List imageData = image.getBytes();

// 创建一个新的Uint8List来存储裁剪后的图像数据
// 注意：这里需要根据你的图像格式（如RGB, RGBA等）来计算大小
  Uint8List croppedImageData = Uint8List(cropWidth * cropHeight * 3); // 假设是RGB

// 遍历原始图像数据，并复制到你感兴趣的区域
  for (int y = 0; y < cropHeight; y++) {
    for (int x = 0; x < cropWidth; x++) {
      // 计算原始图像中的对应位置
      int originalX = cropX + x;
      int originalY = cropY + y;

      // 假设每个像素是4个字节（RGBA）
      int offset = (originalY * originalWidth + originalX) * 3;

      // 复制像素数据
      // 注意：这里需要根据你的图像格式和Uint8List的排列方式调整
      croppedImageData[(y * cropWidth + x) * 3] = imageData[offset]; // R
      croppedImageData[(y * cropWidth + x) * 3 + 1] =
          imageData[offset + 1]; // G
      croppedImageData[(y * cropWidth + x) * 3 + 2] =
          imageData[offset + 2]; // B
      // croppedImageData[(y * cropWidth + x) * 4 + 3] = imageData[offset + 3]; // A
    }
  }
  return croppedImageData;
}
