

List<T> listMapToModel<T>(List<dynamic> listMap, Function jsonF) {
  List<T> list = [];
  for (var item in listMap) {
    list.add(jsonF(item));
  }
  return list;
}