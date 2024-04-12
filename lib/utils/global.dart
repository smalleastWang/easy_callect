


import 'package:easy_collect/models/dict/Dict.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManager {

  int databaseVersion = 3;
  bool isFirstApp = true;
  String dictTableName = 'dicts';
  
  static DatabaseManager? _instance;
  late Database _database;

  // 私有构造函数，确保只能在类内部实例化
  DatabaseManager._internal();

  // 工厂构造函数，返回单例实例
  factory DatabaseManager() {
    _instance ??= DatabaseManager._internal();
    return _instance!;
  }

  get database => _database;

  // 初始化Database
  Future<void> init() async {
    _database = await openDatabase(
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

}
