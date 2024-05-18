import 'package:easy_collect/models/common/Option.dart';

abstract class EnumOption {
  OptionModel<int> toOptionModel();
}
abstract class EnumStrOption {
  OptionModel<String> toOptionModel();
}

// 通用转换函数
enumsToOptions<T extends EnumOption>(List<T> enums) {
  return enums.map((e) => e.toOptionModel()).toList();
}

enumsStrValToOptions<T extends EnumStrOption>(List<T> enums) {
  return enums.map((e) => e.toOptionModel()).toList();
}
