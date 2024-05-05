import 'package:json_annotation/json_annotation.dart';

part 'Milksidentify.g.dart';

@JsonSerializable()
class MilkIdentify {
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
  // 唯一标识码
  String? algorithmCode;
  // 挤奶位编号
  String? milkPos;
  // EasyCVR平台编号
  String? devId;
  // 耳标号
  String? no;
  // 组织机构id
  String? orgId;
  // 组织名称
  String? orgName;
  // 识别时间
  String? identifyTime;
  // 识别牛只图片路径
  String? img;
  // 牛只ID
  String? animalId;
  // 轮次
  String? wave;

  MilkIdentify({
    this.id,
    this.createTime,
    this.createUser,
    this.updateTime,
    this.updateUser,
    this.algorithmCode,
    this.milkPos,
    this.devId,
    this.no,
    this.orgId,
    this.orgName,
    this.identifyTime,
    this.img,
    this.animalId,
    this.wave,
  });

  factory MilkIdentify.fromJson(Map<String, dynamic> json) => _$MilkIdentifyFromJson(json);

  Map<String, dynamic> toJson() => _$MilkIdentifyToJson(this);
}
