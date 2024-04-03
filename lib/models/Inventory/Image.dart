

import 'package:json_annotation/json_annotation.dart';

part 'Image.g.dart';

@JsonSerializable()
class ImageInventoryModel {
  String? id;
  String? createTime;
  String? createUser;
  String? name;
  String? account;
  String? updateTime;
  String? updateUser;
  String? model;
  String? source;
  String? callbackurl;
  String? input;
  String? result;
  String? acceptCode;
  String? acceptResult;
  String? orgId;
  String? resultAmount;

  ImageInventoryModel({
    this.id,
    this.createTime,
    this.createUser,
    this.name,
    this.account,
    this.updateTime,
    this.updateUser,
    this.model,
    this.source,
    this.callbackurl,
    this.input,
    this.result,
    this.acceptCode,
    this.acceptResult,
    this.orgId,
    this.resultAmount
  });
    
  /// 4.添加反序列化方法(格式：factory 类名.fromJson(Map<String, dynamic> json) => _$类名FromJson(json);)
  factory ImageInventoryModel.fromJson(Map<String, dynamic> json) => _$ImageInventoryModelFromJson(json);

  /// 5.添加序列化方法(格式：Map<String, dynamic> toJson() => _$类名ToJson(this);)
  Map<String, dynamic> toJson() => _$ImageInventoryModelToJson(this);
}