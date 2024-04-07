

import 'package:easy_collect/models/dict/Dict.dart';
import 'package:flutter/foundation.dart';

class AppState with ChangeNotifier, DiagnosticableTreeMixin {
  List<DictModel> _dict = [];

  List<DictModel> get dict => _dict;


  List<DictModel> getDictsByPid(String pid) {
    return _dict.where((item) => item.parentId == pid).toList();
  }

  void setDict(data) {
    _dict = data;
    notifyListeners();
  }
}