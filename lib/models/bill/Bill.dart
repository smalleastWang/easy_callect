import 'package:json_annotation/json_annotation.dart';

part 'Bill.g.dart';

/// 账单详细信息类
@JsonSerializable()
class Bill {
  /// 主键ID
  @JsonKey(name: 'id')
  final String? id;

  /// 套餐ID
  @JsonKey(name: 'costId')
  final String? costId;

  /// 购买者名称
  @JsonKey(name: 'gmName')
  final String? gmName;

  /// 缴费状态(数据字典：BILL_PAYMENTSTATUS，0已发布、1已缴费待审批、2财务审批通过、3审批通过、4审批打回)
  @JsonKey(name: 'chargeState')
  final String? chargeState;

  /// 账单类型(数据字典：BILL_TYPE，0购买、1自动)
  @JsonKey(name: 'billType')
  final String? billType;

  /// 账单编号
  @JsonKey(name: 'payNo')
  final String? payNo;

  /// 授权方式（数据字典：authorization_type，0临时授权；1永久授权;2其他）
  @JsonKey(name: 'costType')
  final String? costType;

  /// 缴费基础金额
  @JsonKey(name: 'setPrice')
  final String? setPrice;

  /// 购买数量
  @JsonKey(name: 'purchaseNum')
  final String? purchaseNum;

  /// 总金额
  @JsonKey(name: 'totalPrice')
  final String? totalPrice;

  /// 账单生成时间
  @JsonKey(name: 'createTime')
  final String? createTime;

  /// 缴费人姓名
  @JsonKey(name: 'jfName')
  final String? jfName;

  /// 审批通过时间
  @JsonKey(name: 'approveTime')
  final String? approveTime;

  /// 套餐名称
  @JsonKey(name: 'costName')
  final String? costName;

  /// 套餐牛只/次数/设备数
  @JsonKey(name: 'totalNum')
  final String? totalNum;

  /// 使用数量
  @JsonKey(name: 'usedNum')
  final String? usedNum;

  /// 折扣率
  @JsonKey(name: 'setRate')
  final String? setRate;

  /// 是否自动续费
  @JsonKey(name: 'isAutoRenew')
  final String? isAutoRenew;

  /// 缴费凭证
  @JsonKey(name: 'voucherImg')
  final String? voucherImg;

  /// 套餐类型（数据字典，0按功能收费，1按设备收费）
  @JsonKey(name: 'comboType')
  final String? comboType;

  /// 剩余数量
  @JsonKey(name: 'relayNum')
  final String? relayNum;

  /// 购买记录
  @JsonKey(name: 'purchaseRecordsId')
  final String? purchaseRecordsId;

  /// 到期时间
  @JsonKey(name: 'expirationTime')
  final String? expirationTime;

  /// 购买用户ID
  @JsonKey(name: 'purchaseUserId')
  final String? purchaseUserId;

  /// 转换映射对象
  @JsonKey(name: 'transMap')
  final Map<String, dynamic>? transMap;

  /// 构造函数
  Bill({
    this.id,
    this.costId,
    this.gmName,
    this.chargeState,
    this.billType,
    this.payNo,
    this.costType,
    this.setPrice,
    this.purchaseNum,
    this.totalPrice,
    this.createTime,
    this.jfName,
    this.approveTime,
    this.costName,
    this.totalNum,
    this.usedNum,
    this.setRate,
    this.isAutoRenew,
    this.voucherImg,
    this.comboType,
    this.relayNum,
    this.purchaseRecordsId,
    this.expirationTime,
    this.purchaseUserId,
    this.transMap,
  });

  /// 反序列化方法
  factory Bill.fromJson(Map<String, dynamic> json) => _$BillFromJson(json);

  /// 序列化方法
  Map<String, dynamic> toJson() => _$BillToJson(this);
}