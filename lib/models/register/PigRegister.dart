


import 'package:json_annotation/json_annotation.dart';

part 'PigRegister.g.dart';

@JsonSerializable()
class PigRegisterParams {
  
  String pigNo;
  String pastureId;
  String houseId;
  List<String> faceImgs;
  List<String>? bodyImgs;
  PigRegisterParams({
    required this.pigNo,
    required this.pastureId,
    required this.houseId,
    required this.faceImgs,
    this.bodyImgs,
  });

  factory PigRegisterParams.fromJson(Map<String, dynamic> json) => _$PigRegisterParamsFromJson(json);

  Map<String, dynamic> toJson() => _$PigRegisterParamsToJson(this);
}


@JsonSerializable()
class DistinguishPigAppParams {
  
  String pastureId;
  List<String> faceImgs;
  List<String>? bodyImgs;
  String? earId;
  DistinguishPigAppParams({
    required this.pastureId,
    required this.faceImgs,
    this.earId,
    this.bodyImgs,
  });

  factory DistinguishPigAppParams.fromJson(Map<String, dynamic> json) => _$DistinguishPigAppParamsFromJson(json);

  Map<String, dynamic> toJson() => _$DistinguishPigAppParamsToJson(this);
}

