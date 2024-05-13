
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/widgets/cell/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FinancePage extends StatelessWidget {
  const FinancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(RouteEnum.finance.title),
      ),
      body: Column(
        children: [
          CellWidget(title: '牛只注册', onTap: () => context.push(RouteEnum.cattleRegiter.fullpath!)),
          CellWidget(title: '计数盘点', onTap: () => context.push(RouteEnum.financeCount.fullpath!)),
          CellWidget(title: '牛只识别', onTap: () => context.push(RouteEnum.cattleDiscern.fullpath!)),
          CellWidget(title: '实时视频',onTap: () => context.push(RouteEnum.financeVideo.fullpath!))
        ],
      ),
    );
  }
}