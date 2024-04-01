


import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


final navigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: RouteEnum.home.value,
  routes: routes,
);