import 'package:json_annotation/json_annotation.dart';

part 'Bank.g.dart';

@JsonSerializable()
class Bank {
  String? id;
  String? deleteFlag;
  String? createTime;
  String? createUser;
  String? updateTime;
  String? updateUser;
  String? parentId;
  String? directorId;
  String? name;
  String? code;
  String? category;
  int? sortCode;
  String? extJson;
  String? coordinate;
  String? shortName;
  String? checkTime;
  String? updataTime;
  String? area;
  String? cntTime;

  Bank({
    this.id,
    this.deleteFlag,
    this.createTime,
    this.createUser,
    this.updateTime,
    this.updateUser,
    this.parentId,
    this.directorId,
    this.name,
    this.code,
    this.category,
    this.sortCode,
    this.extJson,
    this.coordinate,
    this.shortName,
    this.checkTime,
    this.updataTime,
    this.area,
    this.cntTime,
  });

  factory Bank.fromJson(Map<String, dynamic> json) => _$BankFromJson(json);

  Map<String, dynamic> toJson() => _$BankToJson(this);
}