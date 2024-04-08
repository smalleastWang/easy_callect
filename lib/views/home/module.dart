import 'package:easy_collect/api/inventory.dart';
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/models/dropDownMenu/DropDownMenu.dart';
import 'package:easy_collect/store/appState.dart';
import 'package:easy_collect/widgets/DropDownMenu/index.dart';
import 'package:easy_collect/widgets/List/ListItem.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    AppState appState = Provider.of<AppState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('功能模块'),
      ),
      body: ListWidget(
        filterList: [
          appState.getDictOptionsByValue('GENDER'),
          appState.getDictOptionsByValue('BRAND'),
          appState.getDictOptionsByValue('BILL_PAYMENTSTATUS'),
        ].map((item) => DropDownMenuModel(
          name: item.name ?? '',
          layerLink: LayerLink(),
          list: item.children?.map((e) => Option(check: false, dictLabel: e.dictLabel, dictValue: e.dictValue)).toList() ?? []
        )).toList(),
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