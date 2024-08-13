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
  List<OptionModel<int>> options = enums.map((e) => e.toOptionModel()).whereNot((e) => e.value == unknownNum).toList();
  if (isUnlimited) {
    options.insert(0, OptionModel<int>(check: false, label: '不限', value: unlimitedNum));
  }
  return options;
}

enumsStrValToOptions<T extends EnumStrOption>(List<T> enums, [bool isUnlimited = false, bool isUnknown = true]) {
  List<OptionModel<String>> options = enums.map((e) => e.toOptionModel()).where((e) => e.value != '-1').toList();

  // 如果 isUnlimited 为 true，添加 "不限" 选项
  if (isUnlimited) {
    options.insert(0, OptionModel<String>(check: false, label: '不限', value: ''));
  }

  // 如果 isUnknown 为 true，保留 "未知" 选项；否则过滤掉它
  if (isUnknown) {
    options.addAll(enums.where((e) => e.toOptionModel().value == '-1').map((e) => e.toOptionModel()));
  }
  return options;
}