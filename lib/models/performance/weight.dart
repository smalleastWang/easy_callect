import 'package:json_annotation/json_annotation.dart';

part 'weight.g.dart';

@JsonSerializable()
class Weight {
  // 组织机构名称
  String? orgName;
  // ID
  String? id;
  // 组织机构ID
  String? orgId;
  // 圈舍ID
  String? buildingId;
  // 圈舍名称
  String? buildName;
  // 牛ID
  String? animalId;
  // 牛耳标号
  String? animalNo;
  // 唯一标识码
  String? algorithmCode;
  // 性能类型，数据字典：PERFORMANCE
  String? dataType;
  // 性能值
  String? dataValue;
  // 日期yyyy-mm-dd
  String? date;
  // 上传时间
  String? updateTime;
  // 与上一次的体重变化值，指标为体重时使用
  String? changeWeight;
  // 间隔天数，指标为体重时使用
  String? intervalDays;
  // 日增重，指标为体重时使用
  String? dailyGain;

  Weight({
    this.orgName,
    this.id,
    this.orgId,
    this.buildingId,
    this.buildName,
    this.animalId,
    this.animalNo,
    this.algorithmCode,
    this.dataType,
    this.dataValue,
    this.date,
    this.updateTime,
    this.changeWeight,
    this.intervalDays,
    this.dailyGain,
  });

  factory Weight.fromJson(Map<String, dynamic> json) => _$WeightFromJson(json);

  Map<String, dynamic> toJson() => _$WeightToJson(this);
}
