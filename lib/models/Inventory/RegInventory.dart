import 'package:json_annotation/json_annotation.dart';

part 'RegInventory.g.dart';

// 识别盘点

@JsonSerializable()
class RegInventory {
  // 盘点ID
  String? id;
  // 盘点时间
  String? checkTime;
  // 盘点类型（0.自动1.手动）
  int? type;
  // 盘点状态（0.盘点中1.盘点结束）
  int? state;
  // 创建日期年月日
  String? inventoryDate;
  // 是否允许自动抵扣盘点套餐 0：不允许 1：允许
  String? allowDeduction;
  // 牧场ID
  String? orgId;
  // 牧场名称
  String? orgName;
  // 盘点结果字典转换后的值
  String? stateName;
  // 圈舍ID
  String? buildingId;
  // 圈舍名称
  String? buildingName;
  // 圈舍可放牛数
  String? maxNum;
  // 实际数量
  String? actualNum;
  // 授权牛数量
  String? authNum;
  // 盘点数量-授权+未授权
  String? inventoryNum;
  // 盘点总数量-授权/授权+盘点套餐抵扣的
  String? inventoryTotalNum;
  // 盘点数量-授权
  String? inventoryAuthNum;
  // 盘点匹配失败数量-授权+未授权
  String? inventoryFailNum;
  // 盘点匹配失败数量-授权
  String? inventoryFailAuthNum;
  // 上次盘点总数量-授权+未授权
  String? lastInventoryTotalNum;
  // 上次盘点总数量-授权
  String? lastInventoryAuthTotalNum;
  // 盘点总重量-授权+未授权
  String? inventoryTotalWeight;
  // 盘点总重量-授权
  String? inventoryAuthTotalWeight;
  // 盘点平均重量-授权
  String? inventoryAuthAvgWeight;
  // 盘点平均重量-授权+未授权
  String? inventoryAvgWeight;
  // 上次盘点平均重量-授权
  String? inventoryLastAvgWeight;
  // 盘点自动扣盘点套餐的数量
  String? deductionNum;
  // 盘点记录ID
  String? inventoryId;

  // 构造函数
  RegInventory({
    this.id,
    this.checkTime,
    this.type,
    this.state,
    this.inventoryDate,
    this.allowDeduction,
    this.orgId,
    this.orgName,
    this.stateName,
    this.buildingId,
    this.buildingName,
    this.maxNum,
    this.actualNum,
    this.authNum,
    this.inventoryNum,
    this.inventoryTotalNum,
    this.inventoryAuthNum,
    this.inventoryFailNum,
    this.inventoryFailAuthNum,
    this.lastInventoryTotalNum,
    this.lastInventoryAuthTotalNum,
    this.inventoryTotalWeight,
    this.inventoryAuthTotalWeight,
    this.inventoryAuthAvgWeight,
    this.inventoryAvgWeight,
    this.inventoryLastAvgWeight,
    this.deductionNum,
    this.inventoryId,
  });

  // 反序列化方法
  factory RegInventory.fromJson(Map<String, dynamic> json) => _$RegInventoryFromJson(json);

  // 序列化方法
  Map<String, dynamic> toJson() => _$RegInventoryToJson(this);
}