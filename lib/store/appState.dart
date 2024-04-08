

import 'package:easy_collect/models/dict/Dict.dart';
import 'package:flutter/foundation.dart';

class AppState with ChangeNotifier, DiagnosticableTreeMixin {
  List<DictModel> _dict = [];

  List<DictModel> get dict => _dict;


  List<DictModel> getDictsByPid(String pid) {
    return _dict.where((item) => item.parentId == pid).toList();
  }
  DictModel getDictOptionsByValue(String val) {
    DictModel pDict = _dict.firstWhere((item) => item.dictValue == val);
    // pDict.children = _dict.where((item) => item.parentId == pDict.id).toList();
    return pDict;
  }

  void setDict(data) {
    _dict = data;
    notifyListeners();
  }
}