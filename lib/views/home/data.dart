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
      ModuleItemModel(route: RouteEnum.standardVerification, iconPath: 'assets/icon/insurance/optimized/11.svg'),
      ModuleItemModel(route: RouteEnum.standardVerificationPig, iconPath: 'assets/icon/insurance/optimized/12.svg'),
      ModuleItemModel(route: RouteEnum.surveyCompared, iconPath: 'assets/icon/insurance/optimized/13.svg'),
      ModuleItemModel(route: RouteEnum.surveyComparedPig, iconPath: 'assets/icon/insurance/optimized/14.svg'),
      ModuleItemModel(route: RouteEnum.orderList, iconPath: 'assets/icon/insurance/optimized/6.svg'),
      ModuleItemModel(route: RouteEnum.insuranceApplicant, iconPath: 'assets/icon/insurance/optimized/10.svg'),
      ModuleItemModel(route: RouteEnum.countRegister, iconPath: 'assets/icon/insurance/optimized/8.svg'),
      // ModuleItemModel(route: RouteEnum.countRegister, iconPath: 'assets/icon/insurance/optimized/9.svg'),
    ]
  ),
  ModuleModel(
    route: RouteEnum.finance,
    bgColor: MyColors.orangeColor,
    children: [
      ModuleItemModel(route: RouteEnum.cattleRegiter, iconPath: 'assets/icon/finance/optimized/1.svg'),
      ModuleItemModel(route: RouteEnum.cattleDiscern, iconPath: 'assets/icon/finance/optimized/2.svg'),
      ModuleItemModel(route: RouteEnum.financeVideo, iconPath: 'assets/icon/finance/optimized/3.svg'),
      ModuleItemModel(route: RouteEnum.countRegister, iconPath: 'assets/icon/finance/optimized/4.svg'),
    ]
  ),
  ModuleModel(
    route: RouteEnum.precisionBreeding,
    bgColor: MyColors.greenColor,
    children: [
      ModuleItemModel(route: RouteEnum.inventory, iconPath: 'assets/icon/precisionBreeding/optimized/1.svg'),
      ModuleItemModel(route: RouteEnum.weight, iconPath: 'assets/icon/precisionBreeding/optimized/2.svg'),
      ModuleItemModel(route: RouteEnum.behavior, iconPath: 'assets/icon/precisionBreeding/optimized/3.svg'),
      ModuleItemModel(route: RouteEnum.performance, iconPath: 'assets/icon/precisionBreeding/optimized/4.svg'),
      ModuleItemModel(route: RouteEnum.position, iconPath: 'assets/icon/precisionBreeding/optimized/5.svg'),
      ModuleItemModel(route: RouteEnum.security, iconPath: 'assets/icon/precisionBreeding/optimized/11.svg'),
      ModuleItemModel(route: RouteEnum.milksidentify, iconPath: 'assets/icon/precisionBreeding/optimized/7.svg'),
      ModuleItemModel(route: RouteEnum.health, iconPath: 'assets/icon/precisionBreeding/optimized/9.svg'),
      ModuleItemModel(route: RouteEnum.intelligencewarn, iconPath: 'assets/icon/precisionBreeding/optimized/6.svg'),
    ]

  ),
  ModuleModel(
    route: RouteEnum.supervision,
    bgColor: MyColors.pinkColor,
    children: [
      ModuleItemModel(route: RouteEnum.mortgageInfo, iconPath: 'assets/icon/supervision/optimized/1.svg'),
      ModuleItemModel(route: RouteEnum.insureInfo, iconPath: 'assets/icon/supervision/optimized/2.svg'),
      ModuleItemModel(route: RouteEnum.breedingScale, iconPath: 'assets/icon/supervision/optimized/3.svg'),
      ModuleItemModel(route: RouteEnum.healthInfo, iconPath: 'assets/icon/supervision/optimized/4.svg'),
    ]

  ),
  ModuleModel(
    route: RouteEnum.common,
    bgColor: MyColors.manageColor,
    children: [
      ModuleItemModel(route: RouteEnum.building, iconPath: 'assets/icon/common/optimized/1.svg'),
      ModuleItemModel(route: RouteEnum.aibox, iconPath: 'assets/icon/common/optimized/2.svg'),
      ModuleItemModel(route: RouteEnum.camera, iconPath: 'assets/icon/common/optimized/3.svg'),
      ModuleItemModel(route: RouteEnum.animal, iconPath: 'assets/icon/common/optimized/4.svg'),
      ModuleItemModel(route: RouteEnum.pigAnimal, iconPath: 'assets/icon/common/optimized/11.svg'),
      ModuleItemModel(route: RouteEnum.email, iconPath: 'assets/icon/common/optimized/5.svg'),
      ModuleItemModel(route: RouteEnum.registerRecord, iconPath: 'assets/icon/common/optimized/13.svg'),
      ModuleItemModel(route: RouteEnum.distinguishRecord, iconPath: 'assets/icon/common/optimized/9.svg'),
      ModuleItemModel(route: RouteEnum.registerPigRecord, iconPath: 'assets/icon/common/optimized/12.svg'),
      ModuleItemModel(route: RouteEnum.distinguishPigRecord, iconPath: 'assets/icon/common/optimized/10.svg'),
    ]
  ),
];