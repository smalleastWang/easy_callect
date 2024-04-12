import 'package:json_annotation/json_annotation.dart';

part 'index.g.dart';

@JsonSerializable()
class RegisterQueryModel {
  // 牛只编号
  String cattleNo;
  // 牧场id
  String pastureId;
  // 圈舍id
  String houseId;
  // 牛脸图片
  List<String> faceImgs;
  // 牛身图片
  List<String>? bodyImgs;
  RegisterQueryModel({
    required this.cattleNo,
    required this.pastureId,
    required this.houseId,
    required this.faceImgs,
    this.bodyImgs,
  });

  factory RegisterQueryModel.fromJson(Map<String, dynamic> json) => _$RegisterQueryModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterQueryModelToJson(this);
}


@JsonSerializable()
class EnclosureModel {
  String id;
  String parentId;
  int weight;
  String name;
  String? nodeType;
  List<EnclosureModel>? children;
  EnclosureModel({
    required this.id,
    required this.parentId,
    required this.name,
    required this.weight,
    this.nodeType,
    this.children,
  });

  factory EnclosureModel.fromJson(Map<String, dynamic> json) => _$EnclosureModelFromJson(json);

  Map<String, dynamic> toJson() => _$EnclosureModelToJson(this);
}