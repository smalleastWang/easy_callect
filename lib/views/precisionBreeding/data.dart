


import 'package:easy_collect/enums/index.dart';
import 'package:easy_collect/models/common/Option.dart';

enum InventoryStatus implements EnumOption {
  inProgress(0, '盘点中'),
  over(1, '盘点结束'),
  unknown(-1, '-');

  final int value;
  final String label;
  const InventoryStatus(this.value, this.label);
  
  static InventoryStatus getTypeByLabel(String title) => InventoryStatus.values.firstWhere((i) => i.name == title, orElse: () => InventoryStatus.unknown);
  static InventoryStatus getTypeByValue(int value) => InventoryStatus.values.firstWhere((i) => i.value == value, orElse: () => InventoryStatus.unknown);

  static int getValue(String label) => InventoryStatus.values.firstWhere((i) => i.label == label, orElse: () => InventoryStatus.unknown).value;
  static String getLabel(int value) => InventoryStatus.values.firstWhere((i) => i.value == value, orElse: () => InventoryStatus.unknown).label;

  @override
  OptionModel<int> toOptionModel() {
    return OptionModel(value: value, label: label);
  }

}


enum InventoryType {
  auto(0, '自动'),
  manual(1, '手动'),
  unknown(-1, '-');

  final int value;
  final String label;
  const InventoryType(this.value, this.label);
  
  static String getLabel(int value) => InventoryType.values.firstWhere((i) => i.value == value, orElse: () => InventoryType.unknown).label;
}

enum WarnType implements EnumOption {
  increaseExercise(0, '运动量增加'),
  reducedExercise(1, '运动量减少'),
  reducedFoodIntake(2, '食量异常'),
  crawlOver(3, '爬跨行为'),
  abnormalLyingTime(4, '躺卧时间异常'),
  deathWarning(5, '死亡预警'),
  outOfCircleWarning(6, '离圈预警'),
  unknown(-1, '未知');

  final int value;
  final String label;
  const WarnType(this.value, this.label);
  
  static WarnType getTypeByLabel(String title) => WarnType.values.firstWhere((i) => i.name == title, orElse: () => WarnType.unknown);
  static WarnType getTypeByValue(int value) => WarnType.values.firstWhere((i) => i.value == value, orElse: () => WarnType.unknown);

  static int getValue(String label) => WarnType.values.firstWhere((i) => i.label == label, orElse: () => WarnType.unknown).value;
  static String getLabel(int value) => WarnType.values.firstWhere((i) => i.value == value, orElse: () => WarnType.unknown).label;

  @override
  OptionModel<int> toOptionModel() {
    return OptionModel(value: value, label: label);
  }
}

// 健康监测类型
enum PostureType implements EnumStrOption {
  healthy('healthy', '健康'),
  dead('dead', '死亡'),
  sick('sick', '疾病'),
  unknown('unknown', '未知');

  final String value;
  final String label;
  const PostureType(this.value, this.label);
  
  static PostureType getTypeByLabel(String title) => PostureType.values.firstWhere((i) => i.name == title, orElse: () => PostureType.unknown);
  static PostureType getTypeByValue(String value) => PostureType.values.firstWhere((i) => i.value == value, orElse: () => PostureType.unknown);

  static String getValue(String label) => PostureType.values.firstWhere((i) => i.label == label, orElse: () => PostureType.unknown).value;
  static String getLabel(String value) => PostureType.values.firstWhere((i) => i.value == value, orElse: () => PostureType.unknown).label;

  @override
  OptionModel<String> toOptionModel() {
    return OptionModel(value: value, label: label);
  }
}

// 保险状态类型
enum PolicyStatus implements EnumStrOption {
  pending('0', '待承保'),
  active('1', '有效'),
  suspended('2', '中止'),
  terminated('3', '终止'),
  unknown('-1', '未知');

  final String value;
  final String label;
  const PolicyStatus(this.value, this.label);
  
  static PolicyStatus getTypeByLabel(String title) => PolicyStatus.values.firstWhere((i) => i.name == title, orElse: () => PolicyStatus.unknown);
  static PolicyStatus getTypeByValue(String value) => PolicyStatus.values.firstWhere((i) => i.value == value, orElse: () => PolicyStatus.unknown);

  static String getValue(String label) => PolicyStatus.values.firstWhere((i) => i.label == label, orElse: () => PolicyStatus.unknown).value;
  static String getLabel(String value) => PolicyStatus.values.firstWhere((i) => i.value == value, orElse: () => PolicyStatus.unknown).label;

  @override
  OptionModel<String> toOptionModel() {
    return OptionModel(value: value, label: label);
  }
}

// 行为类型
enum BehaviorType implements EnumStrOption {
  standing('standing', '站立'),
  lying('lying', '趴卧'),
  feeding('feeding', '采食'),
  crawlover('crawl over', '爬跨'),
  drinking('drinking', '饮水'),
  unknown('-1', '未知');

  final String value;
  final String label;
  const BehaviorType(this.value, this.label);
  
  static BehaviorType getTypeByLabel(String title) => BehaviorType.values.firstWhere((i) => i.name == title, orElse: () => BehaviorType.unknown);
  static BehaviorType getTypeByValue(String value) => BehaviorType.values.firstWhere((i) => i.value == value, orElse: () => BehaviorType.unknown);

  static String getValue(String label) => BehaviorType.values.firstWhere((i) => i.label == label, orElse: () => BehaviorType.unknown).value;
  static String getLabel(String value) => BehaviorType.values.firstWhere((i) => i.value == value, orElse: () => BehaviorType.unknown).label;

  @override
  OptionModel<String> toOptionModel() {
    return OptionModel(value: value, label: label);
  }
}

// 是否启用
enum EnableStatus implements EnumStrOption {
  enable('ENABLE', '是'),
  disenable('DISABLED', '否'),
  unknown('-1', '未知');

  final String value;
  final String label;
  const EnableStatus(this.value, this.label);
  
  static EnableStatus getTypeByLabel(String title) => EnableStatus.values.firstWhere((i) => i.name == title, orElse: () => EnableStatus.unknown);
  static EnableStatus getTypeByValue(String value) => EnableStatus.values.firstWhere((i) => i.value == value, orElse: () => EnableStatus.unknown);

  static String getValue(String label) => EnableStatus.values.firstWhere((i) => i.label == label, orElse: () => EnableStatus.unknown).value;
  static String getLabel(String value) => EnableStatus.values.firstWhere((i) => i.value == value, orElse: () => EnableStatus.unknown).label;

  @override
  OptionModel<String> toOptionModel() {
    return OptionModel(value: value, label: label);
  }
}