import 'package:dio/dio.dart';
import 'package:easy_collect/models/buildings/building.dart';
import 'package:easy_collect/models/common/Area.dart';
import 'package:easy_collect/models/common/Bank.dart';
import 'package:easy_collect/models/dict/Dict.dart';
import 'package:easy_collect/models/register/Upload.dart';
import 'package:easy_collect/utils/global.dart';
import 'package:easy_collect/utils/http/request.dart';
import 'package:easy_collect/utils/tool/common.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'common.g.dart';
class CommonApi {
  // 上传至算法文件服务器图片
  static Future<List<String>> uploadFile(UploadQueryModel params) async {
    Map<String, String> query = {'cattleId': params.cattleId, 'cowId': params.cowId};
    // File file = File(params.filePath);
    // Uint8List bytes = await file.readAsBytes();
    FormData formData = FormData.fromMap({'sysFile': await MultipartFile.fromFile(params.filePath, filename: params.fileName)});
    List<dynamic> data = await HttpUtils.post('/out/v1/uploadImg', params: formData, query: query, isformData: true);
    return data.cast<String>();
  }
  
}



@riverpod
Future<List<AreaModel>> area(AreaRef ref) async {
  List<dynamic> data = await HttpUtils.get('/sys/user/orgTreeSelector');
  List<AreaModel> list = [];
  for (var item in data) {
    list.add(AreaModel.fromJson(item));
  }
  return list;
}

@riverpod
Future<List<AreaModel>> orgTree(AreaRef ref) async {
  List<dynamic> data = await HttpUtils.get('/biz/buildings/orgTreeSelector');
  List<AreaModel> list = [];
  for (var item in data) {
    list.add(AreaModel.fromJson(item));
  }
  return list;
}

@riverpod
Future<List<Building>> building(BuildingRef ref, String orgId) async {
  List<dynamic> data = await HttpUtils.get('/biz/buildings/buildingsSelector?orgId=$orgId');
  List<Building> list = [];
  for (var item in data) {
    list.add(Building.fromJson(item));
  }
  return list;
}

@riverpod
Future<List<DictModel>> dict(DictRef ref) async {
  Database database = DatabaseManager().database;
  String dictTableName = DatabaseManager().dictTableName;
  // 获取接口字典
  List<Map<String, dynamic>> dictMapList = await database.query(dictTableName);
  
  // 获取接口字典
  if (dictMapList.isNotEmpty) {
    // 使用本地数据库数据
    List<DictModel> dictList = listMapToModel(dictMapList, (dict) => DictModel.fromJson(dict));
    return DatabaseManager().listToTree(dictList);
  }

  List<dynamic> res = await HttpUtils.get('/dev/dict/tree');
  List<DictModel> dictTree = [];
  for (var item in res) {
    dictTree.add(DictModel.fromJson(item));
  }
  // 保存数据库
  List<DictModel> dictList = DatabaseManager().treeToList(dictTree);
  Batch databaseBatch = database.batch();
  // 清空
  databaseBatch.execute("DELETE FROM $dictTableName");
  for (var dict in dictList) {
    databaseBatch.insert(dictTableName, dict.toJson());
  }
  await databaseBatch.commit();

  return dictTree;
}

/// 金融机构列表
@riverpod
Future<List<Bank>> bankList(BankListRef ref, Map<String, dynamic> params) async {
  List<dynamic> data = await HttpUtils.get('/biz/animal/bankSelector', params: params);
  List<Bank> list = [];
  for (var item in data) {
    list.add(Bank.fromJson(item));
  }
  return list;
}