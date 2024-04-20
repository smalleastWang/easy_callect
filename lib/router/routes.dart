
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/enums/StorageKey.dart';
import 'package:easy_collect/utils/storage.dart';
import 'package:easy_collect/views/home/index.dart';
import 'package:easy_collect/views/insurance/StandardVerification.dart';
import 'package:easy_collect/views/insurance/index.dart';
import 'package:easy_collect/views/precisionBreeding/index.dart';
import 'package:easy_collect/views/precisionBreeding/inventory.dart';
import 'package:easy_collect/views/my/Login.dart';
import 'package:easy_collect/views/my/UserInfo.dart';
import 'package:go_router/go_router.dart';

final List<GoRoute> routes = [
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
  GoRoute(
    path: RouteEnum.insurance.path,
    builder: (context, state) => const InsurancePage(),
    routes: [
      GoRoute(
        path: RouteEnum.standardVerification.path,
        builder: (context, state) => const StandardVerificationPage(),
      ),

    ]
  ),
  // 精准养殖
  GoRoute(
    path: RouteEnum.precisionBreeding.path,
    builder: (context, state) => const PrecisionBreedingPage(),
    routes: [
      GoRoute(
        path: RouteEnum.inventory.path,
        builder: (context, state) => const InventoryPage(),
      ),

    ]
  ),
];

