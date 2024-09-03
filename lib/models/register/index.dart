import 'package:json_annotation/json_annotation.dart';

part 'index.g.dart';

@JsonSerializable()
class RegisterQueryModel {
  // 牛只编号
  String? cattleNo;
  // 猪编号
  String? pigNo;
  // 牧场id
  String pastureId;
  // 圈舍id
  String houseId;
  // 牛脸图片
  List<String>? faceImgs;
  // 牛身图片
  List<String>? bodyImgs;
  RegisterQueryModel({
    this.cattleNo,
    required this.pastureId,
    required this.houseId,
    this.pigNo,
    this.faceImgs,
    this.bodyImgs,
  });

  factory RegisterQueryModel.fromJson(Map<String, dynamic> json) => _$RegisterQueryModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterQueryModelToJson(this);
}


@JsonSerializable()
class UavRegisterQueryModel {
  // 1、2、0,默认0
  int batch;
  // 牧场id
  String pastureId;
  // 圈舍id
  String houseId;
  // 注册识别盘点功能：1.表示注册 2.表示识别 3.计数盘点)
  int resourceType;
  // 1.表示单个，2表示批量
  int single;
  // 图片
  List<String> imgs;
  // 1图片、2视频
  int? urlType;
  String? taskId;
  
  UavRegisterQueryModel({
    required this.batch,
    required this.pastureId,
    required this.houseId,
    required this.resourceType,
    required this.single,
    required this.imgs,

    this.urlType,
    this.taskId,
  });

  factory UavRegisterQueryModel.fromJson(Map<String, dynamic> json) => _$UavRegisterQueryModelFromJson(json);

  Map<String, dynamic> toJson() => _$UavRegisterQueryModelToJson(this);
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

@JsonSerializable()
class UploadVideoVo {
  String? bucket;
  String? realName;
  int size;
  String? uploadName;
  String url;
  UploadVideoVo({
    this.bucket,
    this.realName,
    required this.size,
    this.uploadName,
    required this.url,
  });

  factory UploadVideoVo.fromJson(Map<String, dynamic> json) => _$UploadVideoVoFromJson(json);

  Map<String, dynamic> toJson() => _$UploadVideoVoToJson(this);
}