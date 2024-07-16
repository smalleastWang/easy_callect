import 'package:json_annotation/json_annotation.dart';

part 'RegisterRecord.g.dart';

// RegisterRecord类
@JsonSerializable()
class RegisterRecord {
  // 主键id
  String? id;
  // 所属牧场
  String? orgId;
  // 所属圈舍
  String? buildingId;
  // 算法生成的唯一识别码
  String? algorithmCode;
  // 牛耳标
  String? no;
  // 注册结果信息
  String? result;
  // 注册时间
  String? createTime;
  // 注册人
  String? createUser;
  // 更新时间
  String? updateTime;
  // 更新人
  String? updateUser;
  // 牛脸照片
  String? faceImg;
  // 牛身照片
  String? bodyImg;
  // 注册状态（0注册成功1注册 失败2待审核）
  String? state;
  // 注册来源0：摄像头端；1:手机端；2其他；3:无人机
  int? registerType;
  // 记录明细id
  String? recordId;
  // 牛只在图片中位置编号
  int? positionNum;

  // 构造函数
  RegisterRecord({
    this.id,
    this.orgId,
    this.buildingId,
    this.algorithmCode,
    this.no,
    this.result,
    this.createTime,
    this.createUser,
    this.updateTime,
    this.updateUser,
    this.faceImg,
    this.bodyImg,
    this.state,
    this.registerType,
    this.recordId,
    this.positionNum,
  });

  // 反序列化方法
  factory RegisterRecord.fromJson(Map<String, dynamic> json) => _$RegisterRecordFromJson(json);

  // 序列化方法
  Map<String, dynamic> toJson() => _$RegisterRecordToJson(this);
}
