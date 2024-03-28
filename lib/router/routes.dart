
import 'package:easy_collect/enums/route.dart';
import 'package:easy_collect/views/home/index.dart';
import 'package:go_router/go_router.dart';

final List<GoRoute> routes = [
  GoRoute(
    path: RouteEnum.home.value,
    builder: (context, state) => const HomePage(),
    routes: const []
  )
];