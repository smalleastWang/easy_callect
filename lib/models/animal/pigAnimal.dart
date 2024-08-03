import 'package:json_annotation/json_annotation.dart';

part 'pigAnimal.g.dart';

@JsonSerializable()
class PigAnimal {
  String? algorithmCode;
  String? bankAuth;
  String? bankAuthEnd;
  String? bankAuthStart;
  String? bindAlgorithmCode;
  String? block;
  String? breed;
  String? buildingId;
  String? buildingName;
  String? bust;
  String? canno;
  String? circum;
  String? comment;
  String? createTime;
  String? createUser;
  String? crossHigh;
  String? fieldState;
  String? growth;
  String? health;
  String? high;
  String? hurdle;
  String? id;
  String? length;
  String? mortEnd;
  String? mortOrg;
  String? mortStart;
  String? mortgage;
  String? no;
  String? orgId;
  String? orgName;
  String? pastureAuth;
  String? pastureAuthEnd;
  String? pastureAuthStart;
  String? plag;
  String? policyNo;
  String? posture;
  String? province;
  int? registerType;
  String? sex;
  int? source;
  String? state;
  String? step;
  String? type;
  String? updateTime;
  String? updateUser;
  String? userName;
  String? weight;
  String? width;

  PigAnimal({
    this.algorithmCode,
    this.bankAuth,
    this.bankAuthEnd,
    this.bankAuthStart,
    this.bindAlgorithmCode,
    this.block,
    this.breed,
    this.buildingId,
    this.buildingName,
    this.bust,
    this.canno,
    this.circum,
    this.comment,
    this.createTime,
    this.createUser,
    this.crossHigh,
    this.fieldState,
    this.growth,
    this.health,
    this.high,
    this.hurdle,
    this.id,
    this.length,
    this.mortEnd,
    this.mortOrg,
    this.mortStart,
    this.mortgage,
    this.no,
    this.orgId,
    this.orgName,
    this.pastureAuth,
    this.pastureAuthEnd,
    this.pastureAuthStart,
    this.plag,
    this.policyNo,
    this.posture,
    this.province,
    this.registerType,
    this.sex,
    this.source,
    this.state,
    this.step,
    this.type,
    this.updateTime,
    this.updateUser,
    this.userName,
    this.weight,
    this.width,
  });

  factory PigAnimal.fromJson(Map<String, dynamic> json) => _$PigAnimalFromJson(json);

  Map<String, dynamic> toJson() => _$PigAnimalToJson(this);
}