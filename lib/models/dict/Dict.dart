
import 'package:json_annotation/json_annotation.dart';

part 'Dict.g.dart';

@JsonSerializable()
class DictModel {
  
  String? id;
  String? category;
  String? deleteFlag;
  String dictLabel;
  String dictValue;
  String? name;
  String? parentId;
  int? sortCode;
  int? weight;
  @JsonKey(includeToJson: false)
  List<DictModel>? children;

  DictModel({
    this.id,
    this.category,
    this.deleteFlag,
    required this.dictLabel,
    required this.dictValue,
    this.name,
    this.parentId,
    this.sortCode,
    this.weight,
    this.children,
  });

  /// 4.添加反序列化方法(格式：factory 类名.fromJson(Map<String, dynamic> json) => _$类名FromJson(json);)
  factory DictModel.fromJson(Map<String, dynamic> json) => _$DictModelFromJson(json);

  /// 5.添加序列化方法(格式：Map<String, dynamic> toJson() => _$类名ToJson(this);)
  Map<String, dynamic> toJson() => _$DictModelToJson(this);
}