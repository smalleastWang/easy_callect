
import 'package:flutter/material.dart';

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