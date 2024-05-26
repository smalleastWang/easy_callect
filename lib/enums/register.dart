

import 'package:easy_collect/enums/index.dart';
import 'package:easy_collect/models/common/Option.dart';


enum RegisterTypeEnum implements EnumOption {
  single(1, '单个注册'),
  multiple(2, '批量注册');
  final int value;
  final String label;

  const RegisterTypeEnum(this.value, this.label);

  @override
  OptionModel<int> toOptionModel() {
    return OptionModel<int>(value: value, label: label);
  }
}

enum RegisterFaceEnum implements EnumOption {
  face(1, '牛脸注册'),
  back(2, '牛背注册');
  final int value;
  final String label;

  const RegisterFaceEnum(this.value, this.label);

  @override
  OptionModel<int> toOptionModel() {
    return OptionModel(value: value, label: label);
  }
}


enum RegisterMediaEnum implements EnumOption {
  face(1, '牛脸注册', RegisterTypeEnum.single),
  back(2, '牛背注册', RegisterTypeEnum.single),
  drones(3, '无人机'),
  // img(4, '图片'),
  video(5, '视频', RegisterTypeEnum.multiple);
  // stream(6, '视频流');
  final int value;
  final String label;
  
  final RegisterTypeEnum? type;

  const RegisterMediaEnum(this.value, this.label, [this.type]);

  @override
  OptionModel<int> toOptionModel() {
    return OptionModel(value: value, label: label);
  }


  static getOptions(RegisterTypeEnum type) => RegisterMediaEnum.values.where((i) => i.type == type || i.type == null).map((e) => e.toOptionModel()).toList();
}



enum SurveyTypeEnum implements EnumOption {
  single(1, '单个查勘'),
  multiple(2, '批量查勘');
  final int value;
  final String label;

  const SurveyTypeEnum(this.value, this.label);

  @override
  OptionModel<int> toOptionModel() {
    return OptionModel(value: value, label: label);
  }
}
enum SurveyMediaEnum implements EnumOption {
  drones(1, '无人机'),
  // img(2, '图片'),
  video(3, '视频');
  // stream(6, '视频流');
  final int value;
  final String label;

  const SurveyMediaEnum(this.value, this.label);

  @override
  OptionModel<int> toOptionModel() {
    return OptionModel(value: value, label: label);
  }
}

enum CountMediaEnum implements EnumStrOption {
  img('cattle-img', '图像盘点'),
  video('cattle-video', '视频盘点'),
  stream('cattle-stream', '视频流盘点');
  // pigImg('pig-img', '猪图片'),
  // pigVideo('pig-video', '猪视频'),
  // pigStream('pig-stream', '猪视频流');
  final String value;
  final String label;

  const CountMediaEnum(this.value, this.label);

  @override
  OptionModel<String> toOptionModel() {
    return OptionModel(value: value, label: label);
  }
  static String getLabel(String value) => CountMediaEnum.values.firstWhere((i) => i.value == value).label;
}

enum ResourceTypeEnum implements EnumOption {
  register(1, '注册'),
  discern(2, '识别'),
  count(3, '计数盘点');
  final int value;
  final String label;

  const ResourceTypeEnum(this.value, this.label);

  @override
  OptionModel<int> toOptionModel() {
    return OptionModel(value: value, label: label);
  }
}


enum OrderStatus {
  inProgress(0, '无效'),
  over(1, '有效'),
  unknown(-1, '-');

  final int value;
  final String label;
  const OrderStatus(this.value, this.label);
  
  static String getLabel(int value) => OrderStatus.values.firstWhere((i) => i.value == value, orElse: () => OrderStatus.unknown).label;
}