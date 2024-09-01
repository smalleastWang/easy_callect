import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:easy_collect/models/PageVo.dart';
import 'package:easy_collect/models/insurance/InsuranceApplicant.dart';
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
  static Future<String> uavUpload(XFile file) async {
    FormData formData = FormData.fromMap({'file': await MultipartFile.fromFile(file.path, filename: file.name)});
    return await HttpUtils.post('/biz/uav/upload', params: formData, isformData: true);
  }
  // 无人机注册
  static Future<void> uavForm(UavRegisterQueryModel params) async {
    await HttpUtils.post('/biz/uav/form', params: params);
  }
  // 视频上传
  static Future<UploadVideoVo> videoUpload(XFile file) async {
    File nFile = File(file.path);
    if (nFile.lengthSync() < 10 * 1024 * 1024) {
      FormData formData = FormData.fromMap({'file': await MultipartFile.fromFile(file.path, filename: file.name)});
      Map<String, dynamic> data = await HttpUtils.post('/video/upload/file', params: formData, isformData: true, isSourceData: true);
      return UploadVideoVo.fromJson(data);
    } else {
      	// 分片数量
      var sFile = await nFile.open();
      try {
        int fileLength = sFile.lengthSync();
        int chunkSize = 5 * 1024 * 1024; // 分片大小 5M
        int chunkNum = (fileLength / chunkSize).ceil();
        int x = 0; // 已经上传的长度
        Map<String, dynamic> data = await HttpUtils.post('/video/multipart/create', params: {
          'chunkSize': chunkNum,
          'fileName': md5.convert(utf8.encode(file.name)).toString()
        }, isSourceData: true);
        while (x < fileLength) {
          // 是否是最后一片了
          bool isLast = fileLength - x >= chunkSize ? false : true;
          // 获取当前这一片的长度，最后一片可能没有设定的分片大小那么长，
          // 想象一根 56cm 长的绳子，一次只取 10cm
          // 最后一次则只能取 56 - 50 = 6cm
          int len = isLast ? fileLength - x : chunkSize;
          // 获取一片
          List<int> postData = sFile.readSync(len).toList();
          
          // 上传分片
          FormData formData = FormData.fromMap({'file': MultipartFile.fromBytes(postData, filename: file.name)});
          await HttpUtils.post('/video/upload/file', params: formData, isformData: true, isSourceData: true);
          // 这里假设已经上传成功
          x += len; // 记录已经取出来的长度
        }
        dynamic result = await HttpUtils.post('/video/multipart/complete', params: {
          'chunkSize': chunkNum,
          'fileName': md5.convert(utf8.encode(file.name)).toString(),
          'uploadId': data['uploadId']
        }, isSourceData: true);
        return UploadVideoVo.fromJson(result);
      } finally {
        sFile.close();
      }
    }    
  }
  // 视频-注册
  static Future<void> videoRegister(UavRegisterQueryModel params) async {
    await HttpUtils.post('/video/register', params: params);
  }
  // 视频-查勘
  static Future<void> videoSurvey(UavRegisterQueryModel params) async {
    await HttpUtils.post('/video/distinguish', params: params);
  }

  // 计数盘点文件上传
  static Future<String> scanAmountUpload(XFile file) async {
    FormData formData = FormData.fromMap({'file': await MultipartFile.fromFile(file.path, filename: file.name)});
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
  if (data.current != 1 && ref.state.hasValue) {
    data.records.insertAll(0, ref.state.value!.records);
  }
  return data;
}

// 新增/编辑保单信息
Future<void> editPolicy(Map<String, dynamic> params) async {
  if(!params['id'].isEmpty) {
      await HttpUtils.post('/biz/policy/edit', params: params);
      return;
  }
  params.remove('id');
  await HttpUtils.post('/biz/policy/add', params: params);
}

/// 保单详情
@riverpod
Future<PageVoModel> insuranceDetail(InsuranceDetailRef ref, Map<String, dynamic> params) async {
  Map<String, dynamic> res = await HttpUtils.get('/biz/insurancedetail/page', params: params);
  PageVoModel data = PageVoModel.fromJson(res);
  if (data.current != 1 && ref.state.hasValue) {
    data.records.insertAll(0, ref.state.value!.records);
  }
  return data;
}

/// 投保人列表
@riverpod
Future<PageVoModel> insuranceApplicantList(InsuranceApplicantListRef ref, Map<String, dynamic> params) async {
  Map<String, dynamic> res = await HttpUtils.get('/biz/insuranceapplicant/page', params: params);
  PageVoModel data = PageVoModel.fromJson(res);
  if (data.current != 1 && ref.state.hasValue) {
    data.records.insertAll(0, ref.state.value!.records);
  }
  return data;
}

/// 投保人选择组件列表
@riverpod
Future<List<InsuranceApplicant>> applicantList(ApplicantListRef ref, Map<String, dynamic> params) async {
  // 发送 HTTP 请求并获取响应数据
  Map<String, dynamic> res = await HttpUtils.get('/biz/insuranceapplicant/page', params: params);
  
  // 将响应数据解析为 PageVoModel
  PageVoModel data = PageVoModel.fromJson(res);
  
  // 将记录转换为 InsuranceApplicant 列表
  List<InsuranceApplicant> list = data.records.map((item) => InsuranceApplicant.fromJson(item)).toList();
  
  // 如果当前页不是第一页，并且有以前的状态，则合并记录
  if (data.current != 1 && ref.state.hasValue) {
    list.insertAll(0, ref.state.value!);
  }
  
  return list;
}

// 新增/编辑投保人
Future<void> editInsuranceApplicant(Map<String, dynamic> params) async {
  if(params['id'] != null) {
      await HttpUtils.post('/biz/insuranceapplicant/edit', params: params);
      return;
  }
  await HttpUtils.post('/biz/insuranceapplicant/add', params: params);
}

// 绑定
Future<void> insurancedetailAdd(Map<String, dynamic> params) async {
  await HttpUtils.post('/biz/insurancedetail/add', params: params);
}