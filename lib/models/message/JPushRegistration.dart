import 'package:json_annotation/json_annotation.dart';

part 'JPushRegistration.g.dart';

@JsonSerializable()
class RegistrationModel {
  String? id;
  String? orgId;
  String? registrationId;
  String? createTime;
  String? createUser;
  String? updateTime;
  String? updateUser;
  RegistrationModel({this.id, this.orgId, this.registrationId, this.createTime, this.createUser, this.updateTime, this.updateUser});

  factory RegistrationModel.fromJson(Map<String, dynamic> json) => _$RegistrationModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegistrationModelToJson(this);
}