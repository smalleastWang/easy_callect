import 'package:dio/dio.dart';
import 'package:easy_collect/models/PageVo.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/utils/http/request.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'insurance.g.dart';

class RegisterApi {
  // 验标注册-校验牛标号是否注册
  static Future<String> isRegister(Map<String, String> params) async {
    return await HttpUtils.post('/out/v1/isRegister', params: params);
  } 
  // 验标注册-注册牛
  static Future<void> cattleApp(RegisterQueryModel params) async {
    await HttpUtils.post('/out/v1/registerCattleAPP', params: params.toJson());
  }
  // 上传无人机图片
  static Future<String> uavUpload(XFile flie) async {
    FormData formData = FormData.fromMap({'file': await MultipartFile.fromFile(flie.path, filename: flie.name)});
    return await HttpUtils.post('/biz/uav/upload', params: formData, isformData: true);
  }
  // 无人机注册
  static Future<void> uavForm(UavRegisterQueryModel params) async {
    await HttpUtils.post('/biz/uav/form', params: params);
  }
  // 视频上传
  static Future<void> videoUpload(XFile flie) async {
    FormData formData = FormData.fromMap({'file': await MultipartFile.fromFile(flie.path, filename: flie.name)});
    await HttpUtils.post('/video/upload/file', params: formData, isformData: true);
  }
  // 视频分片上传
  static Future<void> videoMultipartUpload(XFile flie) async {
    FormData formData = FormData.fromMap({'file': await MultipartFile.fromFile(flie.path, filename: flie.name)});
    await HttpUtils.post('/video/multipart/complete', params: formData, isformData: true);
  }
  // 视频-注册
  static Future<void> videoRsegister(UavRegisterQueryModel params) async {
    await HttpUtils.post('/video/register', params: params);
  }
  // 视频-查勘
  static Future<void> videoSurvey(UavRegisterQueryModel params) async {
    await HttpUtils.post('/video/distinguish', params: params);
  }

  // 计数盘点文件上传
  static Future<String> scanAmountUpload(XFile flie) async {
    FormData formData = FormData.fromMap({'file': await MultipartFile.fromFile(flie.path, filename: flie.name)});
    return await HttpUtils.post('biz/scanAmount/upload', params: formData, isformData: true);
  }
  // 计数盘点
  static Future<void> countInventory(Map<String, dynamic> params) async {
    await HttpUtils.post('/biz/scanAmount/add', params: params);
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

/// 订单列表
@riverpod
Future<PageVoModel> orderList(OrderListRef ref, Map<String, dynamic> params) async {
  Map<String, dynamic> res = await HttpUtils.get('/biz/policy/page', params: params);
  PageVoModel data = PageVoModel.fromJson(res);
  if (params['current'] != 1 && ref.state.hasValue) {
    data.records.insertAll(0, ref.state.value!.records);
  }
  return data;
}