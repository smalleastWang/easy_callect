


import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/router/routes.dart';
import 'package:easy_collect/utils/global.dart';
import 'package:go_router/go_router.dart';


final router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: RouteEnum.home.value,
  routes: routes,
);