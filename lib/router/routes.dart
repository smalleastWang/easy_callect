
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/enums/StorageKey.dart';
import 'package:easy_collect/utils/storage.dart';
import 'package:easy_collect/views/home/index.dart';
import 'package:easy_collect/views/my/Login.dart';
import 'package:go_router/go_router.dart';

final List<GoRoute> routes = [
  GoRoute(
    path: RouteEnum.home.value,
    builder: (context, state) => const HomePage(),
    redirect: (context, state) {
      String? token = SharedPreferencesManager().getString(StorageKeyEnum.token.value);
      if (token == null) {
        return RouteEnum.login.value;
      }
      return null;
    },
    routes: const []
  ),
  GoRoute(
    path: RouteEnum.login.value,
    builder: (context, state) => const LoginPage(),
    routes: const []
  )
];

