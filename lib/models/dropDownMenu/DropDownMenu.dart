
import 'package:easy_collect/widgets/DropDownMenu/index.dart';
import 'package:flutter/material.dart';

enum WidgetType {
  select,
  input,
  picker,
  datePacker,
  rangePicker
}

class DropDownMenuModel {
  LayerLink layerLink;
  String name;
  String fieldName;
  WidgetType widget;
  List<Option> list;

  DropDownMenuModel({
    required this.layerLink,
    required this.name,
    required this.fieldName,
    this.widget =  WidgetType.select,
    this.list = const [],
  });
}