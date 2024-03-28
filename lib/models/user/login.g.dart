// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenInfoModel _$TokenInfoModelFromJson(Map<String, dynamic> json) =>
    TokenInfoModel(
      json['token'] as String,
      json['refresh_token'] as String,
    );

Map<String, dynamic> _$TokenInfoModelToJson(TokenInfoModel instance) =>
    <String, dynamic>{
      'token': instance.token,
      'refresh_token': instance.refreshToken,
    };
