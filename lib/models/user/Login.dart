
import 'package:json_annotation/json_annotation.dart';

part 'Login.g.dart';

@JsonSerializable()
class TokenInfoModel {
  String token;

  @JsonKey(name: 'refresh_token')
  String refreshToken;

  TokenInfoModel(this.token, this.refreshToken);

  /// 4.添加反序列化方法(格式：factory 类名.fromJson(Map<String, dynamic> json) => _$类名FromJson(json);)
  factory TokenInfoModel.fromJson(Map<String, dynamic> json) => _$TokenInfoModelFromJson(json);

  /// 5.添加序列化方法(格式：Map<String, dynamic> toJson() => _$类名ToJson(this);)
  Map<String, dynamic> toJson() => _$TokenInfoModelToJson(this);
}