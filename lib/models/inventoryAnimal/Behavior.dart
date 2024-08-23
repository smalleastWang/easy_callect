import 'package:json_annotation/json_annotation.dart';

part 'Behavior.g.dart';

// 行为分析

@JsonSerializable()
class Behavior {
  // 主键
  String? id;
  // 圈舍
  String? buildingName;
  // 圈舍id
  String? buildingId;
  // 算法提供牛唯一识别码
  String? algorithmCode;
  // 健康状态
  String? health;
  // 身高
  String? high;
  // 体长
  String? length;
  // 姿态
  String? posture;
  // 分钟或者次数
  String? times;
  // 步数
  String? step;
  // 实际重量
  String? weight;
  // 对应智能盘点id
  String? taskId;
  // 盘点时授权状态
  int? currAuthState;
  // 盘点时金融机构授权状态
  int? currFunAuthState;
  // 抵押金融机构
  String? financialId;
  // 抵押金融机构名称
  String? financialName;
  // 牧场id
  String? orgId;
  // 牧场
  String? orgName;
  // 是否是新牛0：否，1：是
  int? isNew;
  // 牛耳标
  String? no;
  // 所在栋
  String? block;
  // 所属栏
  String? hurdle;
  // 是否自动抵消0：否；1：是
  int? autoDeduction;
  // 行为字典名称
  String? postureName;
  // 检测时间
  String? createTime;

  Behavior({
    this.id,
    this.buildingName,
    this.buildingId,
    this.algorithmCode,
    this.health,
    this.high,
    this.length,
    this.posture,
    this.times,
    this.step,
    this.weight,
    this.taskId,
    this.currAuthState,
    this.currFunAuthState,
    this.financialId,
    this.financialName,
    this.orgId,
    this.orgName,
    this.isNew,
    this.no,
    this.block,
    this.hurdle,
    this.autoDeduction,
    this.postureName,
    this.createTime
  });

  factory Behavior.fromJson(Map<String, dynamic> json) => _$BehaviorFromJson(json);

  Map<String, dynamic> toJson() => _$BehaviorToJson(this);
}