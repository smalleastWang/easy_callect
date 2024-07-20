
import 'package:easy_collect/enums/route.dart';
import 'package:easy_collect/views/supervision/BreedingScale.dart';
import 'package:easy_collect/views/supervision/HealthInfo.dart';
import 'package:easy_collect/views/supervision/InsureInfo.dart';
import 'package:easy_collect/views/supervision/MortgageInfo.dart';
import 'package:easy_collect/views/supervision/index.dart';
import 'package:go_router/go_router.dart';

final supervisionRoutes = GoRoute(
  path: RouteEnum.supervision.path,
  builder: (context, state) => const SupervisionPage(),
  routes: [
    GoRoute(
      path: RouteEnum.breedingScale.path,
      builder: (context, state) => const BreedingScalePage(),
    ),
    GoRoute(
      path: RouteEnum.mortgageInfo.path,
      builder: (context, state) => const MortgageInfoPage(),
    ),
    GoRoute(
      path: RouteEnum.insureInfo.path,
      builder: (context, state) => const InsureInfoPage(),
    ),
    GoRoute(
      path: RouteEnum.healthInfo.path,
      builder: (context, state) => const HealthInfoPage(),
    ),
  ]
);