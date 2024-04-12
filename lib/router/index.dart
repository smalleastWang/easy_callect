


import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final routeKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: routeKey,
  // initialLocation: RouteEnum.home.path,
  initialLocation: RouteEnum.standardVerification.fullpath,
  routes: routes,
);