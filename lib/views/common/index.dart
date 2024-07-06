
import 'package:easy_collect/enums/Route.dart';
// import 'package:easy_collect/widgets/cell/index.dart';
import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

class CommonPage extends StatelessWidget {
  const CommonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(RouteEnum.common.title),
      ),
      body: const Column(
        children: [
          // const CellWidget(title: '生成订单'),
          // CellWidget(title: '订单查询', onTap: () => context.push(RouteEnum.orderList.fullpath)),
        ],
      ),
    );
  }
}