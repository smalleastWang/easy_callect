

import 'package:easy_collect/enums/StorageKey.dart';
import 'package:easy_collect/models/common/Area.dart';
import 'package:easy_collect/models/dict/Dict.dart';
import 'package:easy_collect/utils/global.dart';
import 'package:easy_collect/utils/http/request.dart';
import 'package:easy_collect/utils/storage.dart';
import 'package:easy_collect/utils/tool/commot.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'common.g.dart';
class CommonApi {
  // 获取字典
  static Future<List<DictModel>> getDictApi() async {
    List<dynamic> data = await HttpUtils.get('/dev/dict/tree');
    List<DictModel> list = [];
    for (var item in data) {
      list.add(DictModel.fromJson(item));
    }
    return list;
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