


import 'package:json_annotation/json_annotation.dart';

part 'PageVo.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class PageVoModel<T> {
  int current;
  int pages;
  int size;
  int total;
  List<T>? records = [];

  PageVoModel({
    required this.current,
    required this.pages,
    required this.size,
    required this.total,
    required this.records,
  });

 factory PageVoModel.fromJson(Map<String, dynamic> json, T Function(dynamic json) fromJsonT) => _$PageVoModelFromJson<T>(json, fromJsonT);
  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) => _$PageVoModelToJson<T>(this, toJsonT);



}