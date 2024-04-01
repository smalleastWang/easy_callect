
import 'package:json_annotation/json_annotation.dart';

part 'CategoryModel.g.dart';

@JsonSerializable()
class CategoryModel {
  int? id;
  String? name;
  String? icon;
  bool? check;

  CategoryModel({this.id, this.name, this.icon, this.check});

  /// 4.添加反序列化方法(格式：factory 类名.fromJson(Map<String, dynamic> json) => _$类名FromJson(json);)
  factory CategoryModel.fromJson(Map<String, dynamic> json) => _$CategoryModelFromJson(json);

  /// 5.添加序列化方法(格式：Map<String, dynamic> toJson() => _$类名ToJson(this);)
  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}