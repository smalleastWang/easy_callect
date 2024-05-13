
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
          CellWidget(title: '验标注册', onTap: () => context.push(RouteEnum.standardVerification.fullpath!)),
          CellWidget(title: '查勘对比', onTap: () => context.push(RouteEnum.surveyCompared.fullpath!)),
          // const CellWidget(title: '生成订单'),
          CellWidget(title: '订单查询', onTap: () => context.push(RouteEnum.orderList.fullpath!)),
          CellWidget(title: '计数盘点',onTap: () => context.push(RouteEnum.countRegister.fullpath!))
        ],
      ),
    );
  }
}