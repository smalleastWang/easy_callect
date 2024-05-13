import 'package:easy_collect/enums/route.dart';
import 'package:easy_collect/views/finance/CattleDiscern.dart';
import 'package:easy_collect/views/finance/CattleRegiter.dart';
import 'package:easy_collect/views/finance/FinanceCount.dart';
import 'package:easy_collect/views/finance/FinanceVideo.dart';
import 'package:easy_collect/views/finance/index.dart';
import 'package:go_router/go_router.dart';

// 养殖金融
final financeRoutes = GoRoute(
  path: RouteEnum.finance.path,
  builder: (context, state) => const FinancePage(),
  routes: [
    // 牛只注册
    GoRoute(
      path: RouteEnum.cattleRegiter.path,
      builder: (context, state) => const CattleRegiterPage(),
    ),
    // 计数盘点
    GoRoute(
      path: RouteEnum.financeCount.path,
      builder: (context, state) => const FinanceCountPage(),
    ),
    // 牛只识别
    GoRoute(
      path: RouteEnum.cattleDiscern.path,
      builder: (context, state) => const CattleDiscernPage(),
    ),
    // 实时视频
    GoRoute(
      path: RouteEnum.financeVideo.path,
      builder: (context, state) => const FinanceVideoPage(),
    ),
  ],
);