import 'package:json_annotation/json_annotation.dart';

part 'Mortgage.g.dart';

@JsonSerializable()
class Mortgage {
  // 牛只总数
  int? cowNum;
  // 抵押数量
  int? mortgage;
  // 牧场数量
  int? pastureNum;
  // 未抵押数量
  int? unMortgage;

  Mortgage({
    this.cowNum,
    this.mortgage,
    this.pastureNum,
    this.unMortgage,
  });

  factory Mortgage.fromJson(Map<String, dynamic> json) => _$MortgageFromJson(json);

  Map<String, dynamic> toJson() => _$MortgageToJson(this);
}
