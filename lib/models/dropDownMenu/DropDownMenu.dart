
import 'package:easy_collect/models/dict/Dict.dart';
import 'package:flutter/material.dart';

class DropDownMenuModel {
  LayerLink layerLink;
  String name;
  List<DictModel> list;

  DropDownMenuModel({
    required this.name,
    required this.layerLink,
    required this.list,
  });
}