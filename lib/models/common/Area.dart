



import 'package:json_annotation/json_annotation.dart';

part 'Area.g.dart';

@JsonSerializable()
class AreaModel {
  
  String id;
  String name;
  String parentId;
  int weight;
  List<AreaModel>? children;

  AreaModel({
    required this.id,
    required this.name,
    required this.parentId,
    required this.weight,
    required this.children,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) => _$AreaModelFromJson(json);

  Map<String, dynamic> toJson() => _$AreaModelToJson(this);
}