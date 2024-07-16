import 'package:json_annotation/json_annotation.dart';

part 'DistinguishRecord.g.dart';

// DistinguishRecord类
@JsonSerializable()
class DistinguishRecord {
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
  // 无人机牛身图片
  String? uavBodyImgs;
  // 识别时候输入耳标号
  String? inputNo;
  // 创建时间
  String? createTime;
  // 创建人
  String? createUser;
  // 更新时间
  String? updateTime;
  // 更新人
  String? updateUser;
  // 牛脸照片
  String? faceImg;
  // 牛身照片
  String? bodyImg;
  // 识别状态（0识别成功1识别失败）
  String? state;
  // 审核状态（0已审核1未审核）
  String? ischeck;
  // 牧场
  String? orgName;
  // 圈舍
  String? buildingName;
  // 识别照片
  String? distinguishImg;
  // 保险合同号
  String? policyNo;
  // 保险合同状态
  String? policyState;

  // 构造函数
  DistinguishRecord({
    this.id,
    this.orgId,
    this.buildingId,
    this.algorithmCode,
    this.no,
    this.uavBodyImgs,
    this.inputNo,
    this.createTime,
    this.createUser,
    this.updateTime,
    this.updateUser,
    this.faceImg,
    this.bodyImg,
    this.state,
    this.ischeck,
    this.orgName,
    this.buildingName,
    this.distinguishImg,
    this.policyNo,
    this.policyState,
  });

  // 反序列化方法
  factory DistinguishRecord.fromJson(Map<String, dynamic> json) => _$DistinguishRecordFromJson(json);

  // 序列化方法
  Map<String, dynamic> toJson() => _$DistinguishRecordToJson(this);
}
