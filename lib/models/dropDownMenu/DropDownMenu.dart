
import 'package:easy_collect/models/common/Option.dart';
import 'package:flutter/material.dart';

enum WidgetType {
  select,
  input,
  datePicker,
  dateRangePicker
}

class DropDownMenuModel {
  LayerLink layerLink;
  String name;
  String fieldName;
  WidgetType widget;
  String? selectText;
  List<OptionModel> list;
  VoidCallback? onTap;

  DropDownMenuModel({
    required this.layerLink,
    required this.name,
    required this.fieldName,
    this.widget =  WidgetType.select,
    this.list = const [],
    this.onTap,
  });
}