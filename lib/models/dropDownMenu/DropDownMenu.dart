
import 'package:easy_collect/widgets/DropDownMenu/index.dart';
import 'package:flutter/material.dart';

class DropDownMenuModel {
  LayerLink layerLink;
  String name;
  List<Option> list;

  DropDownMenuModel({
    required this.name,
    required this.layerLink,
    required this.list,
  });
}