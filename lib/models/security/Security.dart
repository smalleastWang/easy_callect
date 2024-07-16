import 'package:json_annotation/json_annotation.dart';

part 'Security.g.dart';

//安防报警

@JsonSerializable()
class Security {
  // 组织机构名称
  String? orgName;
  // ID
  String? id;
  // 组织机构ID
  String? orgId;
  // 牛ID
  String? animalId;
  // 牛号
  String? animalNo;
  // 算法唯一识别码
  String? algorithmCode;
  // 设备唯一码
  String? devId;
  // 性能类型，字典SECURITY
  String? dataType;
  // 性能值
  String? dataValue;
  // 日期yyyy-mm-dd
  String? date;
  // 上传时间
  String? updateTime;

  Security({
    this.orgName,
    this.id,
    this.orgId,
    this.animalId,
    this.animalNo,
    this.algorithmCode,
    this.devId,
    this.dataType,
    this.dataValue,
    this.date,
    this.updateTime,
  });

  factory Security.fromJson(Map<String, dynamic> json) => _$SecurityFromJson(json);

  Map<String, dynamic> toJson() => _$SecurityToJson(this);
}
