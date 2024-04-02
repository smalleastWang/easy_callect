import 'package:json_annotation/json_annotation.dart';

part 'UserInfo.g.dart';

@JsonSerializable()
class UserInfoModel {
  String id;
  String avatar;
  String? signature;
  String? account;
  String? name;
  String? nickname;
  String? gender;
  String? age;
  String? birthday;
  String? nation;
  String? nativePlace;
  String? homeAddress;
  String? mailingAddress;
  String? idCardType;
  String? idCardNumber;
  String? cultureLevel;
  String? politicalOutlook;
  String? college;
  String? education;
  String? eduLength;
  String? degree;
  String? phone;
  String? email;
  String? homeTel;
  String? officeTel;
  String? emergencyContact;
  String? emergencyPhone;
  String? emergencyAddress;
  String? empNo;
  String? entryDate;
  String? orgId;
  String? orgName;
  String? positionId;
  String? positionName;
  String? positionLevel;
  String? directorId;
  String? positionJson;
  String? lastLoginIp;
  String? lastLoginAddress;
  String? lastLoginTime;
  String? lastLoginDevice;
  String? latestLoginIp;
  String? latestLoginAddress;
  String? latestLoginTime;
  String? latestLoginDevice;
  String? userStatus;
  int? sortCode;
  String? extJson;
  List<String>? buttonCodeList;
  List<String>? mobileButtonCodeList;
  List<String>? permissionCodeList;
  List<String>? roleIdList;
  List<String>? roleCodeList;
  String? dataScopeList;
  String? password;
  String? userType;
  bool? enabled;

  UserInfoModel({
    required this.id,
    required this.avatar,
    this.signature,
    this.account,
    this.name,
    this.nickname,
    this.gender,
    this.age,
    this.birthday,
    this.nation,
    this.nativePlace,
    this.homeAddress,
    this.mailingAddress,
    this.idCardType,
    this.idCardNumber,
    this.cultureLevel,
    this.politicalOutlook,
    this.college,
    this.education,
    this.eduLength,
    this.degree,
    this.phone,
    this.email,
    this.homeTel,
    this.officeTel,
    this.emergencyContact,
    this.emergencyPhone,
    this.emergencyAddress,
    this.empNo,
    this.entryDate,
    this.orgId,
    this.orgName,
    this.positionId,
    this.positionName,
    this.positionLevel,
    this.directorId,
    this.positionJson,
    this.lastLoginIp,
    this.lastLoginAddress,
    this.lastLoginTime,
    this.lastLoginDevice,
    this.latestLoginIp,
    this.latestLoginAddress,
    this.latestLoginTime,
    this.latestLoginDevice,
    this.userStatus,
    this.sortCode,
    this.extJson,
    this.buttonCodeList,
    this.mobileButtonCodeList,
    this.permissionCodeList,
    this.roleIdList,
    this.roleCodeList,
    this.dataScopeList,
    this.password,
    this.userType,
    this.enabled
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => _$UserInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoModelToJson(this);
}
