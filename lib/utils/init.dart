import 'package:easy_collect/api/common.dart';
import 'package:easy_collect/enums/StorageKey.dart';
import 'package:easy_collect/models/dict/Dict.dart';
import 'package:easy_collect/router/index.dart';
import 'package:easy_collect/store/appState.dart';
import 'package:easy_collect/utils/global.dart';
import 'package:easy_collect/utils/storage.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';


class App {
  int databaseVersion = 3;
  bool isFirstApp = true;
  String dictTableName = 'dicts';

  appInit() async {
    
    // 初始化数据库
    database = await openDatabase(
      join(await getDatabasesPath(), 'easy_database.db'),
      onCreate: (db, version) {
        // NULL, INTEGER=int, REAL=number, TEXT=String, BLOB=Uint8List
        return db.execute('''
          CREATE TABLE $dictTableName(
            id TEXT PRIMARY KEY,
            category TEXT,
            deleteFlag TEXT,
            dictLabel TEXT,
            dictValue TEXT,
            name TEXT,
            parentId TEXT,
            sortCode INTEGER,
            weight INTEGER
          )'''
        );
      },
      version: databaseVersion
    );
    isFirstApp = SharedPreferencesManager().getBool(StorageKeyEnum.isFirstApp.value) ?? true;
    // 初始化字典
    if (isFirstApp) {
      await initDict();
      SharedPreferencesManager().setBool(StorageKeyEnum.isFirstApp.value, false);
    } else {
      // 异步初始化字典
      // initDict();
      List<Map<String, dynamic>> dictMapList = await database.query(dictTableName);
      List<DictModel> dictList = [];
      for (var dict in dictMapList) {
        dictList.add(DictModel.fromJson(dict));
      }
      AppState appState = Provider.of<AppState>(routeKey.currentContext!, listen: false);
      appState.setDict(listToTree(dictList));
    }
  }
  // 获取借口字典并存储到数据库
  initDict() async {
    List<DictModel> dictTree = await CommonApi.getDictApi();
    List<DictModel> dictList = treeToList(dictTree);
    Batch databaseBatch = database.batch();
    // 清空
    databaseBatch.execute("DELETE FROM $dictTableName");
    for (var dict in dictList) {
      databaseBatch.insert(dictTableName, dict.toJson());
    }
    await databaseBatch.commit();
    // 设置字典
    AppState appState = Provider.of<AppState>(routeKey.currentContext!, listen: false);
    appState.setDict(dictTree);
  }
  // 字典 Tree 转 List
  List<DictModel> treeToList(List<DictModel> dict) {
    List<DictModel> result = [];
    loop(List<DictModel>  data) {
      for (var item in data) {
        DictModel resultItem = item;
        result.add(resultItem);
        if (item.children != null) {
          loop(item.children!);
        }
      }
    }
    loop(dict);
    return result;
  }


  // 字典 Tree 转 List
  List<DictModel> listToTree(List<DictModel> dict) {
    Map<String, DictModel> dictMap = {};
    List<DictModel> result = [];
    for (var item in dict) {
      dictMap[item.id!] = item;
    }
    for (var item in dict) {
      DictModel? parent = dictMap[item.parentId];
      if (parent == null) {
        result.add(item);
      } else {
        parent.children != null ? parent.children!.add(item) : parent.children = [item];
      }
    }
    return result;
  }


  widgetInit() {

  }
  
}
