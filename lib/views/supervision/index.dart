import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/widgets/cell/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SupervisionPage extends StatelessWidget {
  const SupervisionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(RouteEnum.supervision.title),
      ),
      body: Column(
        children: [
          CellWidget(title: '养殖规模', onTap: () => context.push(RouteEnum.breedingScale.fullpath)),
          CellWidget(title: '抵押信息', onTap: () => context.push(RouteEnum.mortgageInfo.fullpath)),
          CellWidget(title: '投保信息', onTap: () => context.push(RouteEnum.insureInfo.fullpath)),
          CellWidget(title: '健康检测',onTap: () => context.push(RouteEnum.healthInfo.fullpath))
        ],
      ),
    );
  }
}