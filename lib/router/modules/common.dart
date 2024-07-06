
import 'package:easy_collect/enums/route.dart';
import 'package:easy_collect/views/common/AIBox.dart';
import 'package:easy_collect/views/common/index.dart';
import 'package:go_router/go_router.dart';

final commonRoutes = GoRoute(
  path: RouteEnum.common.path,
  builder: (context, state) => const CommonPage(),
  routes: [
    GoRoute(
      path: RouteEnum.aibox.path,
      builder: (context, state) => const AIBoxPage(),
    ),
    GoRoute(
      path: RouteEnum.aibox.path,
      builder: (context, state) => const AIBoxPage(),
    ),
    GoRoute(
      path: RouteEnum.aibox.path,
      builder: (context, state) => const AIBoxPage(),
    ),
    GoRoute(
      path: RouteEnum.aibox.path,
      builder: (context, state) => const AIBoxPage(),
    ),
  ]
);