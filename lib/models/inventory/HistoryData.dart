import 'package:json_annotation/json_annotation.dart';

part 'HistoryData.g.dart';

@JsonSerializable()
class InventoryHistoryDataVo {

  String buildingName;
  String actualNum;
  String orgName;
  int inventoryNum;

  InventoryHistoryDataVo({
    required this.buildingName,
    required this.actualNum,
    required this.orgName,
    required this.inventoryNum,
  });

   /// 4.添加反序列化方法(格式：factory 类名.fromJson(Map<String, dynamic> json) => _$类名FromJson(json);)
  factory InventoryHistoryDataVo.fromJson(Map<String, dynamic> json) => _$InventoryHistoryDataVoFromJson(json);

  /// 5.添加序列化方法(格式：Map<String, dynamic> toJson() => _$类名ToJson(this);)
  Map<String, dynamic> toJson() => _$InventoryHistoryDataVoToJson(this);

}