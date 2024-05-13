
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/widgets/cell/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PrecisionBreedingPage extends StatelessWidget {
  const PrecisionBreedingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(RouteEnum.precisionBreeding.title),
      ),
      body: Column(
        children: [
          CellWidget(title: '智能盘点', onTap: () => context.push(RouteEnum.inventory.fullpath)),
          CellWidget(title: '性能测定', onTap: () => context.push(RouteEnum.performance.fullpath)),
          CellWidget(title: '智能估重', onTap: () => context.push(RouteEnum.weight.fullpath)),
          CellWidget(title: '行为分析', onTap: () => context.push(RouteEnum.behavior.fullpath)),
          const CellWidget(title: '健康状态'),
          const CellWidget(title: '实时定位'),
          const CellWidget(title: '智能安防'),
          const CellWidget(title: '在位识别')
        ],
      ),
    );
  }
}