

import 'package:easy_collect/enums/route.dart';
import 'package:easy_collect/views/insurance/CountRegister.dart';
import 'package:easy_collect/views/insurance/OrderList.dart';
import 'package:easy_collect/views/insurance/InsuranceApplicant.dart';
import 'package:easy_collect/views/insurance/StandardVerification.dart';
import 'package:easy_collect/views/insurance/StandardVerificationPig.dart';
import 'package:easy_collect/views/insurance/SurveyCompared.dart';
import 'package:easy_collect/views/insurance/SurveyComparedPig.dart';
import 'package:easy_collect/views/insurance/index.dart';
import 'package:go_router/go_router.dart';

// 智慧保险
final insuranceRoutes = GoRoute(
  path: RouteEnum.insurance.path,
  builder: (context, state) => const InsurancePage(),
  routes: [
    // 验标注册-牛
    GoRoute(
      path: RouteEnum.standardVerification.path,
      builder: (context, state) => const StandardVerificationPage(),
    ),
    // 验标注册-猪
    GoRoute(
      path: RouteEnum.standardVerificationPig.path,
      builder: (context, state) => const StandardVerificationPigPage(),
    ),
    // 查勘对比
    GoRoute(
      path: RouteEnum.surveyCompared.path,
      builder: (context, state) => const SurveyComparedPage(),
    ),
    // 查勘对比-猪
    GoRoute(
      path: RouteEnum.surveyComparedPig.path,
      builder: (context, state) => const SurveyComparedPigPage(),
    ),
    GoRoute(
      path: RouteEnum.orderList.path,
      builder: (context, state) => const OrderListPage(),
    ),
    GoRoute(
      path: RouteEnum.insuranceApplicant.path,
      builder: (context, state) => const InsuranceApplicantPage(),
    ),
    // 计数盘点
    GoRoute(
      path: RouteEnum.countRegister.path,
      builder: (context, state) => const CountRegisterPage(),
    ),
  ]
);