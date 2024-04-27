
import 'package:easy_collect/enums/route.dart';
import 'package:easy_collect/views/my/UserInfo.dart';
import 'package:go_router/go_router.dart';

final supervisionRoutes = GoRoute(
  path: RouteEnum.supervision.path,
  builder: (context, state) => const UserInfoPage(),
  routes: const []
);