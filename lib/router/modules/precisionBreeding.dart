

import 'package:easy_collect/enums/route.dart';
import 'package:easy_collect/views/precisionBreeding/Performance.dart';
import 'package:easy_collect/views/precisionBreeding/Security.dart';
import 'package:easy_collect/views/precisionBreeding/index.dart';
import 'package:easy_collect/views/precisionBreeding/Inventory.dart';
import 'package:easy_collect/views/precisionBreeding/Weight.dart';
import 'package:easy_collect/views/precisionBreeding/Behavior.dart';
import 'package:easy_collect/views/precisionBreeding/Health.dart';
import 'package:easy_collect/views/precisionBreeding/Intelligencewarn.dart';
import 'package:easy_collect/views/precisionBreeding/Position.dart';
import 'package:easy_collect/views/precisionBreeding/Milksidentify.dart';
import 'package:easy_collect/views/precisionBreeding/inventory/HistoryData.dart';
import 'package:easy_collect/views/precisionBreeding/inventory/SetTime.dart';
import 'package:go_router/go_router.dart';

// 精准养殖
final precisionBreedingRoutes = GoRoute(
  path: RouteEnum.precisionBreeding.path,
  builder: (context, state) => const PrecisionBreedingPage(),
  routes: [
    // 智能盘点
    GoRoute(
      path: RouteEnum.inventory.path,
      builder: (context, state) => const InventoryPage(),
      routes: [
        GoRoute(
          path: RouteEnum.inventorySetTime.path,
          builder: (context, state) => const SetTimePage(RouteEnum.inventorySetTime),
        ),
        GoRoute(
          path: RouteEnum.inventorySetUploadTime.path,
          builder: (context, state) => const SetTimePage(RouteEnum.inventorySetUploadTime),
        ),
        GoRoute(
          path: RouteEnum.inventoryHistoryData.path,
          builder: (context, state) {
            final extra = state.extra as Map<String, String>;
            return HistoryData(extra['buildingId']!);
          },
        ),
      ]
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
    // 智能预警
    GoRoute(
      path: RouteEnum.intelligencewarn.path,
      builder: (context, state) => const IntelligencewarnPage(),
    ),
     // 智能安防
    GoRoute(
      path: RouteEnum.security.path,
      builder: (context, state) => const SecurityPage(),
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