import 'package:collection/collection.dart';
import 'package:easy_collect/models/common/Option.dart';
import 'package:easy_collect/utils/const.dart';

abstract class EnumOption {
  OptionModel<int> toOptionModel();
}
abstract class EnumStrOption {
  OptionModel<String> toOptionModel();
}

// 通用转换函数
enumsToOptions<T extends EnumOption>(List<T> enums, [bool isUnlimited = false]) {
  List<OptionModel> options = enums.map((e) => e.toOptionModel()).whereNot((e) => e.value == unknownNum).toList();
  if (isUnlimited) {
    options.insert(0, OptionModel(check: false, label: '不限', value: unlimitedNum));
  }
  return options;
}

enumsStrValToOptions<T extends EnumStrOption>(List<T> enums, [bool isUnlimited = false]) {
  List<OptionModel<String>> options = enums.map((e) => e.toOptionModel()).whereNot((e) => e.value == '').toList();
  if (isUnlimited) {
    options.insert(0, OptionModel(check: false, label: '不限', value: ''));
  }
  return options;
}