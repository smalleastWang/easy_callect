

import 'package:easy_collect/enums/route.dart';
import 'package:easy_collect/views/precisionBreeding/Performance.dart';
import 'package:easy_collect/views/precisionBreeding/index.dart';
import 'package:easy_collect/views/precisionBreeding/Inventory.dart';
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

  ],
);