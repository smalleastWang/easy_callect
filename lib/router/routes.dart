
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/enums/StorageKey.dart';
import 'package:easy_collect/router/modules/finance.dart';
import 'package:easy_collect/router/modules/insurance.dart';
import 'package:easy_collect/router/modules/precisionBreeding.dart';
import 'package:easy_collect/router/modules/supervision.dart';
import 'package:easy_collect/utils/storage.dart';
import 'package:easy_collect/views/home/index.dart';
import 'package:easy_collect/views/my/Login.dart';
import 'package:easy_collect/views/my/UserInfo.dart';
import 'package:go_router/go_router.dart';

final List<GoRoute> routes = [
  // GoRoute(
  //   path: RouteEnum.cameraRegister.path,
  //   builder: (context, state) => const CameraMlVision(mTaskMode: EnumTaskMode.cowBodyRegister),
  //   routes: const []
  // ),
  GoRoute(
    path: RouteEnum.home.path,
    builder: (context, state) => const HomePage(),
    redirect: (context, state) {
      String? token = SharedPreferencesManager().getString(StorageKeyEnum.token.value);
      if (token == null) {
        return RouteEnum.login.path;
      }
      return null;
    },
    routes: const []
  ),
  GoRoute(
    path: RouteEnum.login.path,
    builder: (context, state) => const LoginPage(),
    routes: const []
  ),
  GoRoute(
    path: RouteEnum.userInfo.path,
    builder: (context, state) => const UserInfoPage(),
    routes: const []
  ),
  
  // 智慧保险
  insuranceRoutes,
  // 养殖金融
  financeRoutes,
  // 精准养殖
  precisionBreedingRoutes,
  // 行业监督
  supervisionRoutes
];

