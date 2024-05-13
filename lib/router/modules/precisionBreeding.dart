

import 'package:easy_collect/enums/route.dart';
import 'package:easy_collect/views/precisionBreeding/Performance.dart';
import 'package:easy_collect/views/precisionBreeding/index.dart';
import 'package:easy_collect/views/precisionBreeding/Inventory.dart';
import 'package:easy_collect/views/precisionBreeding/Weight.dart';
import 'package:easy_collect/views/precisionBreeding/Behavior.dart';
import 'package:easy_collect/views/precisionBreeding/Health.dart';
import 'package:easy_collect/views/precisionBreeding/Position.dart';
import 'package:easy_collect/views/precisionBreeding/Milksidentify.dart';
import 'package:go_router/go_router.dart';

// 精准养殖
final precisionBreedingRoutes = GoRoute(
  path: RouteEnum.precisionBreeding.path,
  builder: (context, state) => const PrecisionBreedingPage(),
  routes: [
    // 盘点管理
    GoRoute(
      path: RouteEnum.inventory.path,
      builder: (context, state) => const InventoryPage(),
    ),
    // 性能测定
    GoRoute(
      path: RouteEnum.performance.path,
      builder: (context, state) => const PerformancePage(),
    ),
    // 智能估重
    GoRoute(
      path: RouteEnum.weight.path,
      builder: (context, state) => const WeightPage(),
    ),
    // 行为分析
    GoRoute(
      path: RouteEnum.behavior.path,
      builder: (context, state) => const BehaviorPage(),
    ),
    // 健康状态
    GoRoute(
      path: RouteEnum.health.path,
      builder: (context, state) => const HealthPage(),
    ),
    // 实时定位
    GoRoute(
      path: RouteEnum.position.path,
      builder: (context, state) => const PositionPage(),
    ),
     // 在位识别
    GoRoute(
      path: RouteEnum.milksidentify.path,
      builder: (context, state) => const MilksidentifyPage(),
    ),
  ],
);