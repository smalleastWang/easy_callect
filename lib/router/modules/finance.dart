import 'package:easy_collect/enums/route.dart';
import 'package:easy_collect/views/precisionBreeding/index.dart';
import 'package:easy_collect/views/precisionBreeding/Inventory.dart';
import 'package:go_router/go_router.dart';

// 养殖金融
final financeRoutes = GoRoute(
  path: RouteEnum.finance.path,
  builder: (context, state) => const PrecisionBreedingPage(),
  routes: [
    GoRoute(
      path: RouteEnum.inventory.path,
      builder: (context, state) => const InventoryPage(),
    ),
  ],
);