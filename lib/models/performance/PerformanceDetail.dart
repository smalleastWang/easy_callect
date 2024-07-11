import 'package:json_annotation/json_annotation.dart';

part 'PerformanceDetail.g.dart';

@JsonSerializable()
class PerformanceDetail {
  // 唯一标识码
  String? algorithmCode;
  // 牛ID
  String? animalId;
  // 牛耳标号
  String? animalNo;
  // 圈舍名称
  String? buildName;
  // 圈舍ID
  String? buildingId;
  // 与上一次的体重变化值
  String? changeWeight;
  // 日增重
  String? dailyGain;
  // 性能类型，数据字典：PERFORMANCE
  String? dataType;
  // 性能值
  String? dataValue;
  // 日期yyyy-mm-dd
  String? date;
  // 日
  String? day;
  // ID
  String? id;
  // 间隔天数
  String? intervalDays;
  // 月
  String? month;
  // 组织机构ID
  String? orgId;
  // 组织机构名称
  String? orgName;
  // 上传时间
  String? updateTime;
  // 年
  String? year;

  PerformanceDetail({
    this.algorithmCode,
    this.animalId,
    this.animalNo,
    this.buildName,
    this.buildingId,
    this.changeWeight,
    this.dailyGain,
    this.dataType,
    this.dataValue,
    this.date,
    this.day,
    this.id,
    this.intervalDays,
    this.month,
    this.orgId,
    this.orgName,
    this.updateTime,
    this.year,
  });

  factory PerformanceDetail.fromJson(Map<String, dynamic> json) => _$PerformanceDetailFromJson(json);

  Map<String, dynamic> toJson() => _$PerformanceDetailToJson(this);
}