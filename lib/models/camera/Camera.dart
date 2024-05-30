import 'package:json_annotation/json_annotation.dart';

part 'Camera.g.dart';

// 摄像头

@JsonSerializable()
class Camera {
  // 权限
  bool? auth;
  // 权限结束时间
  String? authEnd;
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
  // 牧场id
  String? orgId;
  // 圈舍id
  String? buildingId;
  // 所属ai盒子id
  String? aiboxId;
  // 名称
  String? name;
  // 品牌
  String? brand;
  // 型号
  String? model;
  // 账号
  String? account;
  // 密码
  String? password;
  // 启用状态
  String? state;
  // 在线状态
  String? online;
  // COMMENTS
  String? comments;
  // 设备序列号
  String? sn;
  // EasyCVR平台编号
  String? easyCvrId;
  // 监控视频地址
  String? monitorUrl;
  // 算法视频地址
  String? algorithmUrl;
  // 实时视频地址
  String? realtimeUrl;
  // 是否默认算法视频
  String? isDefault;
  // 是否展示算法视频
  String? isShow;
  // 牧场名称
  String? orgName;
  // 圈舍名称
  String? buildingName;
  // MAC地址
  String? macAddr;

  // 构造函数
  Camera({
    this.auth,
    this.authEnd,
    this.id,
    this.createTime,
    this.createUser,
    this.updateTime,
    this.updateUser,
    this.orgId,
    this.buildingId,
    this.aiboxId,
    this.name,
    this.brand,
    this.model,
    this.account,
    this.password,
    this.state,
    this.online,
    this.comments,
    this.sn,
    this.easyCvrId,
    this.monitorUrl,
    this.algorithmUrl,
    this.realtimeUrl,
    this.isDefault,
    this.isShow,
    this.orgName,
    this.buildingName,
    this.macAddr,
  });

  // 反序列化方法
  factory Camera.fromJson(Map<String, dynamic> json) => _$CameraFromJson(json);

  // 序列化方法
  Map<String, dynamic> toJson() => _$CameraToJson(this);
}