import 'package:json_annotation/json_annotation.dart';

part 'building.g.dart';

// 圈舍管理

@JsonSerializable()
class Building {
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
  // 圈舍名称
  String? buildingName;
  // 牧场ID
  String? orgId;
  // 最大牛数量
  String? maxNum;
  // 栋数量
  String? blockNum;
  // 栏数量
  String? hurdleNum;
  // 当前牛数量
  String? currentNum;
  // 备注
  String? comment;
  // 状态（0可用1禁用）
  String? state;
  // 是否有牛只授权，0否，1：是
  int? isAuth;
  // 摄像头分布图
  String? cameraMap;
  // 圈舍类型 0：正式圈舍；1：临时圈舍
  String? type;
  // 监控视频展示数量：1、4、9
  String? monitorCnt;
  // 算法视频展示数量：1、4、9
  String? algorithmCnt;
  // 组织名称
  String? orgName;

  Building({
    this.id,
    this.createTime,
    this.createUser,
    this.updateTime,
    this.updateUser,
    this.buildingName,
    this.orgId,
    this.maxNum,
    this.blockNum,
    this.hurdleNum,
    this.currentNum,
    this.comment,
    this.state,
    this.isAuth,
    this.cameraMap,
    this.type,
    this.monitorCnt,
    this.algorithmCnt,
    this.orgName,
  });

  factory Building.fromJson(Map<String, dynamic> json) => _$BuildingFromJson(json);

  Map<String, dynamic> toJson() => _$BuildingToJson(this);
}