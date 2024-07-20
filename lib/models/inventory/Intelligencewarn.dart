import 'package:json_annotation/json_annotation.dart';

part 'Intelligencewarn.g.dart';

// 智能预警

@JsonSerializable()
class Intelligencewarn {
  // 主键
  String? id;
  
  // 创建时间
  String? createTime;
  
  // 牧场ID
  String? orgId;
  
  // 创建人
  String? createUser;
  
  // 修改时间
  String? updateTime;
  
  // 修改人
  String? updateUser;
  
  // 圈舍id
  String? buildingId;
  
  // 牛只id
  String? animalId;
  
  // 算法提供牛唯一识别码
  String? algorithmCode;
  
  // 耳标号
  String? no;
  
  // 预警类型  1 运动量减少  2 食量减少  3
  String? warnType;
  
  // 预警时间(预留)
  String? warnDate;
  
  // 组织名称
  String? orgName;
  
  // 预警类型名称
  String? warnTypeName;

  Intelligencewarn({
    this.id,
    this.createTime,
    this.orgId,
    this.createUser,
    this.updateTime,
    this.updateUser,
    this.buildingId,
    this.animalId,
    this.algorithmCode,
    this.no,
    this.warnType,
    this.warnDate,
    this.orgName,
    this.warnTypeName,
  });

  factory Intelligencewarn.fromJson(Map<String, dynamic> json) => _$IntelligencewarnFromJson(json);

  Map<String, dynamic> toJson() => _$IntelligencewarnToJson(this);
}