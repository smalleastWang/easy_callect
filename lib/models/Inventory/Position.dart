import 'package:json_annotation/json_annotation.dart';

part 'Position.g.dart';

//实时定位

@JsonSerializable()
class Actual {
  // 牧场ID
  String? orgId;
  // 牧场名称
  String? orgName;
  // 圈舍ID
  String? buildingId;
  // 圈舍名称
  String? buildingName;
  // 采集日期
  String? inventoryDate;
  // 唯一标识码
  String? algorithmCode;
  // 耳标号
  String? animalNo;
  // 身高
  String? high;
  // 体长
  String? length;
  // 体重
  String? weight;
  // 步数
  String? step;

  Actual({
    this.orgId,
    this.orgName,
    this.buildingId,
    this.buildingName,
    this.inventoryDate,
    this.algorithmCode,
    this.animalNo,
    this.high,
    this.length,
    this.weight,
    this.step,
  });

  factory Actual.fromJson(Map<String, dynamic> json) => _$ActualFromJson(json);

  Map<String, dynamic> toJson() => _$ActualToJson(this);
}
