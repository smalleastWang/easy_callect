import 'package:easy_collect/api/inventory.dart';
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/widgets/List/ListItem.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:flutter/material.dart';

class ModuleListModel {
  RouteEnum route;
  Color background;
  ModuleListModel({required this.route, required this.background});
}


class ModuleWidget extends StatefulWidget {
  const ModuleWidget({super.key});

  @override
  State<ModuleWidget> createState() => _ModuleWidgetState();
}

class _ModuleWidgetState extends State<ModuleWidget> {
  final List moduleList = [
    ModuleListModel(route: RouteEnum.inventory, background: Colors.black),
    ModuleListModel(route: RouteEnum.performance, background: Colors.black),
    ModuleListModel(route: RouteEnum.weight, background: Colors.black),
    ModuleListModel(route: RouteEnum.health, background: Colors.black),
    ModuleListModel(route: RouteEnum.position, background: Colors.black),
    ModuleListModel(route: RouteEnum.security, background: Colors.black),
    ModuleListModel(route: RouteEnum.pen, background: Colors.black),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('功能模块'),
      ),
      body: ListWidget(
        api: InventoryApi.getImageApi,
        columns: [
          ListColumnModal(label: '模型类型', field: 'model'),
          ListColumnModal(label: '客户唯一索引', field: 'source'),
          ListColumnModal(label: '资源', field: 'input'),
          ListColumnModal(label: '识别数量', field: 'resultAmount'),
          ListColumnModal(label: '创建时间', field: 'createTime'),
        ],

      ),
    );
  }
}