import 'package:json_annotation/json_annotation.dart';

part 'CntInventory.g.dart';

// 计数盘点

@JsonSerializable()
class CntInventoryModel {
  // ID
  String? id;
  // 创建时间
  String? createTime;
  // 创建人
  String? createUser;
  // 修改时间
  String? updateTime;
  // 修改人
  String? updateUser;
  // 盘点时间
  String? checkTime;
  // 盘点类型（0.自动1.手动）
  int? type;
  // 盘点状态（0.盘点中1.盘点结束）
  int? state;
  // 盘点日期年月日
  String? inventoryDate;
  // 牧场ID
  String? orgId;
  // 盘点状态字典转换后的值
  String? stateName;
  // 盘点类型字典转换后的值
  String? typeName;
  // 圈舍ID
  String? buildingId;
  // 圈舍名称
  String? buildingName;
  // 牧场名称
  String? orgName;
  // 实际数量
  String? actualNum;
  // 盘点记录ID
  String? inventoryId;
  // 上次盘点时间
  String? lastTime;
  // 上次盘点数量
  String? lastNum;

  // 构造函数
  CntInventoryModel({
    this.id,
    this.createTime,
    this.createUser,
    this.updateTime,
    this.updateUser,
    this.checkTime,
    this.type,
    this.state,
    this.inventoryDate,
    this.orgId,
    this.stateName,
    this.typeName,
    this.buildingId,
    this.buildingName,
    this.orgName,
    this.actualNum,
    this.inventoryId,
    this.lastTime,
    this.lastNum,
  });

  // 反序列化方法
  factory CntInventoryModel.fromJson(Map<String, dynamic> json) => _$CntInventoryModelFromJson(json);

  // 序列化方法
  Map<String, dynamic> toJson() => _$CntInventoryModelToJson(this);
}
