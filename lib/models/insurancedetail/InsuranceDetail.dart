import 'package:json_annotation/json_annotation.dart';

part 'InsuranceDetail.g.dart';

/// 保险详细信息类
@JsonSerializable()
class InsuranceDetail {
  /// 索引
  @JsonKey(name: 'index')
  final int? index;

  /// 农户（机构）名称
  @JsonKey(name: 'farmerName')
  final String? farmerName;

  /// 所属机构
  @JsonKey(name: 'orgId')
  final String? orgId;

  /// 起始耳标号/序号
  @JsonKey(name: 'startNo')
  final String? startNo;

  /// 终止耳标号/序号
  @JsonKey(name: 'endNo')
  final String? endNo;

  /// 身份证号码
  @JsonKey(name: 'idCardNumber')
  final String? idCardNumber;

  /// 保险合同号
  @JsonKey(name: 'policyNo')
  final String? policyNo;

  /// 性别（0公 1母）
  @JsonKey(name: 'animalSex')
  final String? animalSex;

  /// 其他证件号码
  @JsonKey(name: 'otherCardNumber')
  final String? otherCardNumber;

  /// 保险项目
  @JsonKey(name: 'policyContent')
  final String? policyContent;

  /// 畜龄
  @JsonKey(name: 'animalAge')
  final String? animalAge;

  /// 农户地址
  @JsonKey(name: 'farmerAddress')
  final String? farmerAddress;

  /// 保险费
  @JsonKey(name: 'premium')
  final double? premium;

  /// 毛色（0黑1白2红3黑白花4其他）
  @JsonKey(name: 'coatColor')
  final String? coatColor;

  /// 联系电话
  @JsonKey(name: 'tel')
  final String? tel;

  /// 创建时间
  @JsonKey(name: 'time')
  final String? time;

  /// 畜别
  @JsonKey(name: 'animalType')
  final String? animalType;

  /// 养殖地点
  @JsonKey(name: 'breedingBase')
  final String? breedingBase;

  /// 保险合同生效日期
  @JsonKey(name: 'effectiveTime')
  final String? effectiveTime;

  /// 畜种
  @JsonKey(name: 'animalBreed')
  final String? animalBreed;

  /// 保险合同期满日期
  @JsonKey(name: 'expiryTime')
  final String? expiryTime;

  /// 养殖数量
  @JsonKey(name: 'totalNum')
  final int? totalNum;

  /// 品种
  @JsonKey(name: 'animalVariety')
  final String? animalVariety;

  /// 银行账号
  @JsonKey(name: 'bankAccount')
  final String? bankAccount;

  /// 联系人
  @JsonKey(name: 'person')
  final String? person;

  /// 账户名称
  @JsonKey(name: 'accountName')
  final String? accountName;

  /// 健康状况(0是1否)
  @JsonKey(name: 'isHealthy')
  final String? isHealthy;

  /// 联系电话
  @JsonKey(name: 'phone')
  final String? phone;

  /// 银行名称
  @JsonKey(name: 'bankName')
  final String? bankName;

  /// 是否有检验(0是1否)
  @JsonKey(name: 'isQuarantine')
  final String? isQuarantine;

  /// 保单状态
  @JsonKey(name: 'state')
  final int? state;

  /// 承保数量
  @JsonKey(name: 'insuranceNum')
  final String? insuranceNum;

  /// 农户地址经度
  @JsonKey(name: 'longitude')
  final String? longitude;

  /// 单位保额
  @JsonKey(name: 'insuranceAmount')
  final String? insuranceAmount;

  /// 农户地址纬度
  @JsonKey(name: 'latitude')
  final String? latitude;

  /// 银行地址
  @JsonKey(name: 'bankAddress')
  final String? bankAddress;

  /// 市场价格（单价）
  @JsonKey(name: 'marketValue')
  final String? marketValue;

  /// 开户行省
  @JsonKey(name: 'bankProvince')
  final String? bankProvince;

  /// 评定价格（单价）
  @JsonKey(name: 'evaluateValue')
  final String? evaluateValue;

  /// 投保人表id
  @JsonKey(name: 'applicantId')
  final String? applicantId;

  /// 开户行市
  @JsonKey(name: 'bankCity')
  final String? bankCity;

  /// 是否贫困户
  @JsonKey(name: 'isPoverty')
  final String? isPoverty;

  /// 保单表id
  @JsonKey(name: 'policyId')
  final String? policyId;

  /// 算法生成的牛只唯一码
  @JsonKey(name: 'algorithmCode')
  final String? algorithmCode;

  /// 备注
  @JsonKey(name: 'remarks')
  final String? remarks;

  /// 关联圈舍表id
  @JsonKey(name: 'buildingId')
  final String? buildingId;

  /// 创建时间
  @JsonKey(name: 'createTime')
  final String? createTime;

  /// 创建人
  @JsonKey(name: 'createUser')
  final String? createUser;

  /// 识别状态（0识别成功1识别失败）
  @JsonKey(name: 'distinguishState')
  final String? distinguishState;

  /// 更新时间
  @JsonKey(name: 'updateTime')
  final String? updateTime;

  /// 更新人
  @JsonKey(name: 'updateUser')
  final String? updateUser;

  /// 构造函数
  InsuranceDetail({
    this.index,
    this.farmerName,
    this.orgId,
    this.startNo,
    this.endNo,
    this.idCardNumber,
    this.policyNo,
    this.animalSex,
    this.otherCardNumber,
    this.policyContent,
    this.animalAge,
    this.farmerAddress,
    this.premium,
    this.coatColor,
    this.tel,
    this.time,
    this.animalType,
    this.breedingBase,
    this.effectiveTime,
    this.animalBreed,
    this.expiryTime,
    this.totalNum,
    this.animalVariety,
    this.bankAccount,
    this.person,
    this.accountName,
    this.isHealthy,
    this.phone,
    this.bankName,
    this.isQuarantine,
    this.state,
    this.insuranceNum,
    this.longitude,
    this.insuranceAmount,
    this.latitude,
    this.bankAddress,
    this.marketValue,
    this.bankProvince,
    this.evaluateValue,
    this.applicantId,
    this.bankCity,
    this.isPoverty,
    this.policyId,
    this.algorithmCode,
    this.remarks,
    this.buildingId,
    this.createTime,
    this.createUser,
    this.distinguishState,
    this.updateTime,
    this.updateUser,
  });

  /// 反序列化方法
  factory InsuranceDetail.fromJson(Map<String, dynamic> json) => _$InsuranceDetailFromJson(json);

  /// 序列化方法
  Map<String, dynamic> toJson() => _$InsuranceDetailToJson(this);
}