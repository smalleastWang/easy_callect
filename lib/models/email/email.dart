import 'package:json_annotation/json_annotation.dart';

part 'email.g.dart';

// Email类
@JsonSerializable()
class Email {
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
  // 牧场id
  String? orgId;
  // 姓名
  String? name;
  // 角色代码
  int? roleCode;
  // 邮箱
  String? emails;
  // 牧场
  String? orgName;

  // 构造函数
  Email({
    this.id,
    this.createTime,
    this.createUser,
    this.updateTime,
    this.updateUser,
    this.orgId,
    this.name,
    this.roleCode,
    this.emails,
    this.orgName,
  });

  // 反序列化方法
  factory Email.fromJson(Map<String, dynamic> json) => _$EmailFromJson(json);

  // 序列化方法
  Map<String, dynamic> toJson() => _$EmailToJson(this);
}