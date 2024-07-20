


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
  reducedExercise(1, '运动量减少'),
  reducedFoodIntake(2, '食量减少'),
  reducedWeight(3, '体重减少'),
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