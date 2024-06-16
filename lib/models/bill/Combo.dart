import 'package:json_annotation/json_annotation.dart';

part 'Combo.g.dart';

/// 套餐详细信息类
@JsonSerializable()
class Combo {
  /// 主键ID
  @JsonKey(name: 'id')
  final String? id;

  /// 套餐名称
  @JsonKey(name: 'costName')
  final String costName;

  /// 套餐类型
  @JsonKey(name: 'comboType')
  final String? comboType;

  /// 授权方式
  @JsonKey(name: 'costType')
  final String? costType;

  /// 计费类型
  @JsonKey(name: 'chargeType')
  final String? chargeType;

  /// 是否启用
  @JsonKey(name: 'isEnable')
  final String? isEnable;

  /// 备注
  @JsonKey(name: 'remark')
  final String? remark;

  /// 是否删除
  @JsonKey(name: 'isDeleted')
  final String? isDeleted;

  /// 最大赠送次数
  @JsonKey(name: 'giveMaxTimes')
  final String? giveMaxTimes;

  /// 最大购买次数
  @JsonKey(name: 'buyMaxTimes')
  final String? buyMaxTimes;

  /// 是否免费
  @JsonKey(name: 'isToFree')
  final String? isToFree;

  /// 最大免费次数
  @JsonKey(name: 'freeMaxTimes')
  final String? freeMaxTimes;

  /// 最大免费数量
  @JsonKey(name: 'freeMaxNum')
  final String? freeMaxNum;

  /// 是否允许授权
  @JsonKey(name: 'allowAuth')
  final String? allowAuth;

  /// 剩余通知数量
  @JsonKey(name: 'leftNoticeNum')
  final String? leftNoticeNum;

  /// 延长天数
  @JsonKey(name: 'extendDay')
  final String? extendDay;

  /// 创建时间
  @JsonKey(name: 'createTime')
  final String? createTime;

  /// 可用功能列表
  @JsonKey(name: 'canUseFunctions')
  final List<CanUseFunctions>? canUseFunctions;

  /// 构造函数
  Combo({
    this.id,
    required this.costName,
    this.comboType,
    this.costType,
    this.chargeType,
    this.isEnable,
    this.remark,
    this.isDeleted,
    this.giveMaxTimes,
    this.buyMaxTimes,
    this.isToFree,
    this.freeMaxTimes,
    this.freeMaxNum,
    this.allowAuth,
    this.leftNoticeNum,
    this.extendDay,
    this.createTime,
    this.canUseFunctions,
  });

  /// 反序列化方法
  factory Combo.fromJson(Map<String, dynamic> json) => _$ComboFromJson(json);

  /// 序列化方法
  Map<String, dynamic> toJson() => _$ComboToJson(this);
}

/// 功能详细信息类
@JsonSerializable()
class CanUseFunctions {
  /// 主键ID
  @JsonKey(name: 'id')
  final String? id;

  /// 创建时间
  @JsonKey(name: 'createTime')
  final String? createTime;

  /// 创建人
  @JsonKey(name: 'createUser')
  final String? createUser;

  /// 修改时间
  @JsonKey(name: 'updateTime')
  final String? updateTime;

  /// 修改人
  @JsonKey(name: 'updateUser')
  final String? updateUser;

  /// 模块ID
  @JsonKey(name: 'moduleId')
  final String? moduleId;

  /// 功能名称
  @JsonKey(name: 'name')
  final String? name;

  /// 功能编码
  @JsonKey(name: 'code')
  final String? code;

  /// 状态
  @JsonKey(name: 'state')
  final String? state;

  /// 是否允许授权
  @JsonKey(name: 'allowAuth')
  final String? allowAuth;

  /// 类型
  @JsonKey(name: 'type')
  final String? type;

  /// 备注
  @JsonKey(name: 'remark')
  final String? remark;

  /// 构造函数
  CanUseFunctions({
    this.id,
    this.createTime,
    this.createUser,
    this.updateTime,
    this.updateUser,
    this.moduleId,
    this.name,
    this.code,
    this.state,
    this.allowAuth,
    this.type,
    this.remark,
  });

  /// 反序列化方法
  factory CanUseFunctions.fromJson(Map<String, dynamic> json) => _$CanUseFunctionsFromJson(json);

  /// 序列化方法
  Map<String, dynamic> toJson() => _$CanUseFunctionsToJson(this);
}