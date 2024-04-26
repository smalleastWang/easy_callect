
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/widgets/cell/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InsurancePage extends StatelessWidget {
  const InsurancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(RouteEnum.insurance.title),
      ),
      body: Column(
        children: [
          CellWidget(title: '验标注册', onTap: () => context.go(RouteEnum.standardVerification.fullpath!)),
          CellWidget(title: '查勘对比', onTap: () => context.go(RouteEnum.surveyCompared.fullpath!)),
          const CellWidget(title: '生成订单'),
          const CellWidget(title: '订单查询'),
          const CellWidget(title: '计数盘点')
        ],
      ),
    );
  }
}