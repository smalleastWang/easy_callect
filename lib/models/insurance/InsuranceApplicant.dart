import 'package:json_annotation/json_annotation.dart';

part 'InsuranceApplicant.g.dart';

// 保险申请人

@JsonSerializable()
class InsuranceApplicant {
  // ID
  String? id;
  // 农户（机构）名称（*）
  String? farmerName;
  // 身份证号码
  String? idCardNumber;
  // 其他证件类型
  String? otherCardNumber;
  // 农户地址
  String? farmerAddress;
  // 联系电话（*）
  String? phone;
  // 养殖地点（*）
  String? breedingBase;
  // 养殖数量（*）
  String? totalNum;
  // 银行账号（*）
  String? bankAccount;
  // 账户名称（*）
  String? accountName;
  // 银行名称（*）
  String? bankName;
  // 农户地址经度
  String? longitude;
  // 农户地址维度
  String? latitude;
  // 银行地址
  String? bankAddress;
  // 开户行省（*）
  String? bankProvince;
  // 开户行市（*）
  String? bankCity;
  // 是否贫困户
  String? isPoverty;
  // 备注
  String? remarks;
  // 关联圈舍表id
  String? buildingId;
  // 组织
  String? orgId;

  // 构造函数
  InsuranceApplicant({
    this.id,
    this.farmerName,
    this.idCardNumber,
    this.otherCardNumber,
    this.farmerAddress,
    this.phone,
    this.breedingBase,
    this.totalNum,
    this.bankAccount,
    this.accountName,
    this.bankName,
    this.longitude,
    this.latitude,
    this.bankAddress,
    this.bankProvince,
    this.bankCity,
    this.isPoverty,
    this.remarks,
    this.buildingId,
    this.orgId,
  });

  // 反序列化方法
  factory InsuranceApplicant.fromJson(Map<String, dynamic> json) => _$InsuranceApplicantFromJson(json);

  // 序列化方法
  Map<String, dynamic> toJson() => _$InsuranceApplicantToJson(this);
}