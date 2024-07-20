import 'package:json_annotation/json_annotation.dart';

part 'Monitoring.g.dart';

@JsonSerializable()
class Monitoring {
  // 牛只总数
  int? cowNum;
  // 抵押数量
  int? mortgage;
  // 牧场数量
  int? pastureNum;
  // 未抵押数量
  int? unMortgage;
  // 健康数量	
  int? health;
  // 不健康数量
  int? unHealth;
  // 投保数量	
  int? policy;
  // 不投保数量	
  int? unPolicy;

  Monitoring({
    this.cowNum,
    this.mortgage,
    this.pastureNum,
    this.unMortgage,
    this.health,
    this.unHealth,
  });

  factory Monitoring.fromJson(Map<String, dynamic> json) => _$MonitoringFromJson(json);

  Map<String, dynamic> toJson() => _$MonitoringToJson(this);
}
