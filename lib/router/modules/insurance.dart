

import 'package:easy_collect/enums/route.dart';
import 'package:easy_collect/views/insurance/StandardVerification.dart';
import 'package:easy_collect/views/insurance/SurveyCompared.dart';
import 'package:easy_collect/views/insurance/index.dart';
import 'package:go_router/go_router.dart';

// 智慧保险
final insuranceRoutes = GoRoute(
  path: RouteEnum.insurance.path,
  builder: (context, state) => const InsurancePage(),
  routes: [
    // 验标注册
    GoRoute(
      path: RouteEnum.standardVerification.path,
      builder: (context, state) => const StandardVerificationPage(),
    ),
    // 查勘对比
    GoRoute(
      path: RouteEnum.surveyCompared.path,
      builder: (context, state) => const SurveyComparedPage(),
    ),

  ]
);