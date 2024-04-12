


import 'package:json_annotation/json_annotation.dart';

part 'Upload.g.dart';

@JsonSerializable()
class UploadQueryModel {
  
  String cattleId;
  String cowId;
  String filePath;
  String fileName;
  UploadQueryModel({
    required this.cattleId,
    required this.cowId,
    required this.filePath,
    required this.fileName,
  });

  factory UploadQueryModel.fromJson(Map<String, dynamic> json) => _$UploadQueryModelFromJson(json);

  Map<String, dynamic> toJson() => _$UploadQueryModelToJson(this);
}