import 'package:easy_collect/enums/route.dart';
import 'package:easy_collect/utils/colors.dart';
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
  String iconPath;
  ModuleItemModel({required this.route, required this.iconPath, this.title});
}

final List<ModuleModel> moduleList = [
  ModuleModel(
    route: RouteEnum.insurance,
    bgColor: MyColors.insuranceColor,
    children: [
      ModuleItemModel(route: RouteEnum.standardVerification, iconPath: 'assets/icon/insurance/1.png'),
      ModuleItemModel(route: RouteEnum.surveyCompared, iconPath: 'assets/icon/insurance/5.png'),
      ModuleItemModel(route: RouteEnum.orderList, iconPath: 'assets/icon/insurance/6.png'),
      ModuleItemModel(route: RouteEnum.countRegister, iconPath: 'assets/icon/insurance/8.png')
    ]
  ),
  ModuleModel(
    route: RouteEnum.finance,
    bgColor: MyColors.orangeColor,
    children: [
      ModuleItemModel(route: RouteEnum.cattleRegiter, iconPath: 'assets/icon/finance/1.png'),
      ModuleItemModel(route: RouteEnum.cattleDiscern, iconPath: 'assets/icon/finance/2.png'),
      ModuleItemModel(route: RouteEnum.financeVideo, iconPath: 'assets/icon/finance/3.png'),
      ModuleItemModel(route: RouteEnum.financeCount, iconPath: 'assets/icon/finance/4.png'),
    ]
  ),
  ModuleModel(
    route: RouteEnum.precisionBreeding,
    bgColor: MyColors.greenColor,
    children: [
      ModuleItemModel(route: RouteEnum.inventory, iconPath: 'assets/icon/precisionBreeding/1.png'),
      ModuleItemModel(route: RouteEnum.weight, iconPath: 'assets/icon/precisionBreeding/2.png'),
      ModuleItemModel(route: RouteEnum.behavior, iconPath: 'assets/icon/precisionBreeding/3.png'),
      ModuleItemModel(route: RouteEnum.performance, iconPath: 'assets/icon/precisionBreeding/4.png'),
      ModuleItemModel(route: RouteEnum.position, iconPath: 'assets/icon/precisionBreeding/5.png'),
      ModuleItemModel(route: RouteEnum.security, iconPath: 'assets/icon/precisionBreeding/6.png'),
      ModuleItemModel(route: RouteEnum.milksidentify, iconPath: 'assets/icon/precisionBreeding/7.png'),
      ModuleItemModel(route: RouteEnum.countRegister, iconPath: 'assets/icon/precisionBreeding/8.png'),

      // ModuleItemModel(route: RouteEnum.health, iconPath: 'assets/icon/precisionBreeding/1.png'),
      // ModuleItemModel(route: RouteEnum.intelligencewarn, iconPath: 'assets/icon/precisionBreeding/1.png'),
    ]

  ),
  ModuleModel(
    route: RouteEnum.supervision,
    bgColor: MyColors.pinkColor,
    children: [
      ModuleItemModel(route: RouteEnum.mortgageInfo, iconPath: 'assets/icon/supervision/1.png'),
      ModuleItemModel(route: RouteEnum.insureInfo, iconPath: 'assets/icon/supervision/2.png'),
      ModuleItemModel(route: RouteEnum.breedingScale, iconPath: 'assets/icon/supervision/3.png'),
      ModuleItemModel(route: RouteEnum.healthCheck, iconPath: 'assets/icon/supervision/4.png'),
    ]

  ),
  ModuleModel(
    route: RouteEnum.common,
    bgColor: MyColors.manageColor,
    children: [
      ModuleItemModel(route: RouteEnum.building, iconPath: 'assets/icon/common/1.png'),
      ModuleItemModel(route: RouteEnum.aibox, iconPath: 'assets/icon/common/2.png'),
      ModuleItemModel(route: RouteEnum.camera, iconPath: 'assets/icon/common/3.png'),
      ModuleItemModel(route: RouteEnum.animal, iconPath: 'assets/icon/common/4.png'),
      ModuleItemModel(route: RouteEnum.aibox, iconPath: 'assets/icon/common/5.png'),
    ]

  ),
];