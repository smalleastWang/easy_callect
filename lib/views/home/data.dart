import 'package:easy_collect/enums/route.dart';
import 'package:easy_collect/utils/colors.dart';
import 'package:easy_collect/utils/icons.dart';
import 'package:flutter/material.dart';

class ModuleModel {
  RouteEnum? route;
  String? title;
  Color bgColor;
  List<ModuleItemModel> children;
  ModuleModel({this.route, required this.children, this.title, required this.bgColor});
}
class ModuleItemModel {
  RouteEnum route;
  String? title;
  IconData icon;
  ModuleItemModel({required this.route, required this.icon, this.title});
}

final List<ModuleModel> moduleList = [
  ModuleModel(
    route: RouteEnum.insurance,
    bgColor: MyColors.insuranceColor,
    children: [
      ModuleItemModel(route: RouteEnum.standardVerification, icon: MyIcons.helpManual),
      ModuleItemModel(route: RouteEnum.insurance, icon: MyIcons.surveyCompared),
      ModuleItemModel(route: RouteEnum.orderList, icon: MyIcons.surveyCompared),
      ModuleItemModel(route: RouteEnum.countRegister, icon: MyIcons.surveyCompared)
    ]

  ),
  ModuleModel(
    route: RouteEnum.finance,
    bgColor: MyColors.orangeColor,
    children: [
      ModuleItemModel(route: RouteEnum.insurance, icon: MyIcons.helpManual),
      ModuleItemModel(route: RouteEnum.cattleRegiter, icon: MyIcons.helpManual),
      ModuleItemModel(route: RouteEnum.financeCount, icon: MyIcons.helpManual),
      ModuleItemModel(route: RouteEnum.cattleDiscern, icon: MyIcons.helpManual),
      ModuleItemModel(route: RouteEnum.financeVideo, icon: MyIcons.helpManual),
    ]
  ),
  ModuleModel(
    route: RouteEnum.precisionBreeding,
    bgColor: MyColors.greenColor,
    children: [
      ModuleItemModel(route: RouteEnum.inventory, icon: MyIcons.helpManual),
      ModuleItemModel(route: RouteEnum.performance, icon: MyIcons.helpManual),
      ModuleItemModel(route: RouteEnum.weight, icon: MyIcons.helpManual),
      ModuleItemModel(route: RouteEnum.behavior, icon: MyIcons.helpManual),
      ModuleItemModel(route: RouteEnum.health, icon: MyIcons.helpManual),
      ModuleItemModel(route: RouteEnum.intelligencewarn, icon: MyIcons.helpManual),
      ModuleItemModel(route: RouteEnum.position, icon: MyIcons.helpManual),
    ]

  ),
  ModuleModel(
    route: RouteEnum.supervision,
    bgColor: MyColors.pinkColor,
    children: [
      ModuleItemModel(route: RouteEnum.breedingScale, icon: MyIcons.helpManual),
      ModuleItemModel(route: RouteEnum.mortgageInfo, icon: MyIcons.helpManual),
      ModuleItemModel(route: RouteEnum.insureInfo, icon: MyIcons.helpManual),
      ModuleItemModel(route: RouteEnum.healthCheck, icon: MyIcons.helpManual),
    ]

  ),
];