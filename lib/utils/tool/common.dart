
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

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
  const characters = '+-*=?AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
  Random random = Random();
  return String.fromCharCodes(Iterable.generate(length, (_) => characters.codeUnitAt(random.nextInt(characters.length))));
}