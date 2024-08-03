
import 'package:easy_collect/enums/route.dart';
import 'package:easy_collect/views/common/PigAnimal.dart';
import 'package:easy_collect/views/common/index.dart';
import 'package:easy_collect/views/common/Building.dart';
import 'package:easy_collect/views/common/AIBox.dart';
import 'package:easy_collect/views/common/Camera.dart';
import 'package:easy_collect/views/common/Animal.dart';
import 'package:easy_collect/views/common/RegisterRecord.dart';
import 'package:easy_collect/views/common/DistinguishRecord.dart';
import 'package:easy_collect/views/common/Email.dart';
import 'package:go_router/go_router.dart';

final commonRoutes = GoRoute(
  path: RouteEnum.common.path,
  builder: (context, state) => const CommonPage(),
  routes: [
    GoRoute(
      path: RouteEnum.building.path,
      builder: (context, state) => const BuildingPage(),
    ),
    GoRoute(
      path: RouteEnum.aibox.path,
      builder: (context, state) => const AIBoxPage(),
    ),
    GoRoute(
      path: RouteEnum.camera.path,
      builder: (context, state) => const CameraPage(),
    ),
    GoRoute(
      path: RouteEnum.animal.path,
      builder: (context, state) => const AnimalPage(),
    ),
    GoRoute(
      path: RouteEnum.pigAnimal.path,
      builder: (context, state) => const PigAnimalPage(),
    ),
    GoRoute(
      path: RouteEnum.email.path,
      builder: (context, state) => const EmailPage(),
    ),
    GoRoute(
      path: RouteEnum.registerRecord.path,
      builder: (context, state) => const RegisterRecordPage(),
    ),
    GoRoute(
      path: RouteEnum.distinguishRecord.path,
      builder: (context, state) => const DistinguishRecordPage(),
    ),
  ]
);