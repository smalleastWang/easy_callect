  
  
  import 'package:easy_collect/models/dict/Dict.dart';

List<DictModel> getDictsByPid(List<DictModel>dict, String pid) {
  return dict.where((item) => item.parentId == pid).toList();
}

DictModel getDictOptionsByValue(List<DictModel> dict, String val, String fieldName, [String? name]) {
  DictModel pDict = dict.firstWhere((item) => item.dictValue == val);
  pDict.fieldName = fieldName;
  if (name != null) pDict.name = name;
  // pDict.children = _dict.where((item) => item.parentId == pDict.id).toList();
  return pDict;
}