import 'package:dio/dio.dart';
import 'package:easy_collect/models/index.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/utils/http/request.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'register.g.dart';

class RegisterApi {
  // 注册牛
  static Future<String> cattleApp(RegisterQueryModel params) async {
    CommonMap data = await HttpUtils.post('/out/v1/registerCattleAPP', params: params.toJson());
    return 'list';
  } 

  // 上传无人机图片
  static Future<String> uavUpload(XFile flie) async {
    FormData formData = FormData.fromMap({'file': await MultipartFile.fromFile(flie.path, filename: flie.name)});
    CommonMap data = await HttpUtils.post('/biz/uav/upload', params: formData, isformData: true);
    return 'list';
  }
  static Future<String> uavForm(XFile flie) async {
    FormData formData = FormData.fromMap({'file': await MultipartFile.fromFile(flie.path, filename: flie.name)});
    CommonMap data = await HttpUtils.post('/biz/uav/form', params: formData, isformData: true);
    return 'list';
  }

  
}

@riverpod
Future<List<EnclosureModel>> enclosureList(EnclosureListRef ref) async {
  List<dynamic> res = await HttpUtils.post('/out/v1/getOrgAndBuildings');
  List<EnclosureModel> list = [];
  for (var item in res) {
    list.add(EnclosureModel.fromJson(item));
  }
  return list;
}