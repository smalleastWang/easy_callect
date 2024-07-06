import 'package:json_annotation/json_annotation.dart';

part 'aibox.g.dart';

// AI盒子

@JsonSerializable()
class AIBox {
  // 主键
  String? id;
  // 创建时间
  String? createTime;
  // 创建人
  String? createUser;
  // 修改时间
  String? updateTime;
  // 修改人
  String? updateUser;
  // 状态（0,正常,1删除）
  String? state;
  // 牧场id
  String? orgId;
  // 圈舍id
  String? buildingId;
  // 盒子名称
  String? name;
  // 品牌
  String? brand;
  // 型号
  String? model;
  // 盒子编号
  String? boxNo;
  // 0 离线 1在线
  String? online;
  // 牧场
  String? orgName;
  // 圈舍
  String? buildingName;
  // 图片
  String? imgSrc;

  // 构造函数
  AIBox({
    this.id,
    this.createTime,
    this.createUser,
    this.updateTime,
    this.updateUser,
    this.state,
    this.orgId,
    this.buildingId,
    this.name,
    this.brand,
    this.model,
    this.boxNo,
    this.online,
    this.orgName,
    this.buildingName,
    this.imgSrc,
  });

  // 反序列化方法
  factory AIBox.fromJson(Map<String, dynamic> json) => _$AIBoxFromJson(json);

  // 序列化方法
  Map<String, dynamic> toJson() => _$AIBoxToJson(this);
}