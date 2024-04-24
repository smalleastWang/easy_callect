import 'package:dio/dio.dart';
import 'package:easy_collect/models/index.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/utils/http/request.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'register.g.dart';

class RegisterApi {
  // 注册牛
  static Future<void> cattleApp(RegisterQueryModel params) async {
    await HttpUtils.post('/out/v1/registerCattleAPP', params: params.toJson());
  } 

  // 上传无人机图片
  static Future<void> uavUpload(XFile flie) async {
    FormData formData = FormData.fromMap({'file': await MultipartFile.fromFile(flie.path, filename: flie.name)});
    CommonMap data = await HttpUtils.post('/biz/uav/upload', params: formData, isformData: true);
    print(data);
  }
  // 无人机注册
  static Future<void> uavForm(XFile flie) async {
    await HttpUtils.post('/biz/uav/form', params: {}, isformData: true);
  }
  
}

/// 牧场圈舍信息
@riverpod
Future<List<EnclosureModel>> enclosureList(EnclosureListRef ref) async {
  List<dynamic> res = await HttpUtils.post('/out/v1/getOrgAndBuildings');
  List<EnclosureModel> list = [];
  for (var item in res) {
    list.add(EnclosureModel.fromJson(item));
  }
  return list;
}