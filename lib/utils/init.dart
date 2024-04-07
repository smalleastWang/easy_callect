
import 'package:easy_collect/api/common.dart';
import 'package:easy_collect/enums/StorageKey.dart';
import 'package:easy_collect/models/dict/Dict.dart';
import 'package:easy_collect/store/appState.dart';
import 'package:easy_collect/utils/global.dart';
import 'package:easy_collect/utils/storage.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';


class App {
  int databaseVersion = 1;
  bool isFirstApp = true;
  String dictTableName = 'dicts';

  appInit() async {
    // 初始化存储
    await SharedPreferencesManager().init();
    // 初始化数据库
    database = await openDatabase(
      join(await getDatabasesPath(), 'easy_database.db'),
      onCreate: (db, version) {
        // NULL, INTEGER=int, REAL=number, TEXT=String, BLOB=Uint8List
        return db.execute('CREATE TABLE $dictTableName(id TEXT PRIMARY KEY, category TEXT, deleteFlag String, dictLabel String, dictValue String, name String, parentId String, sortCode INTEGER, weight INTEGER, check INTEGER)');
      },
      version: databaseVersion
    );
    isFirstApp = SharedPreferencesManager().getBool(StorageKeyEnum.isFirstApp.value) ?? true;
    // 初始化字典
    if (isFirstApp) {
      await initDict();
      // SharedPreferencesManager().setBool(StorageKeyEnum.isFirstApp.value, false);
    } else {
      // 异步初始化字典
      // initDict();
      // await database.query(dictTableName);
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
    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      AppState appState = Provider.of<AppState>(navigatorKey.currentContext!, listen: false);
      appState.setDict(dictList);
    });
  }
  // 字典 Tree 转 List
  List<DictModel> treeToList(List<DictModel> dict) {
    const List<DictModel> result = [];
    loop(List<DictModel>  data) {
      for (var item in data) {
        result.add(item);
        if (item.children != null) {
          loop(item.children!);
        }
      }
    }
    loop(dict);
    return result;
  }

  
}