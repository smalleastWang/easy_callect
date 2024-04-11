import 'package:easy_collect/api/common.dart';
import 'package:easy_collect/api/inventory.dart';
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/models/dict/Dict.dart';
import 'package:easy_collect/models/dropDownMenu/DropDownMenu.dart';
import 'package:easy_collect/utils/tool/dict.dart';
import 'package:easy_collect/widgets/DropDownMenu/index.dart';
import 'package:easy_collect/widgets/List/ListItem.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:easy_collect/widgets/LoadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ModuleListModel {
  RouteEnum route;
  Color background;
  ModuleListModel({required this.route, required this.background});
}

class ListDemoWidget extends ConsumerStatefulWidget {
  const ListDemoWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ListDemoWidgetState();
}

class _ListDemoWidgetState extends ConsumerState<ListDemoWidget> {
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
    final AsyncValue<List<DictModel>> dict = ref.watch(dictProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('功能模块'),
      ),
      body: LoadingWidget(
        data: dict,
        builder: (BuildContext context, value) {
          return ListWidget<ImageInventoryFamily>(
            filterList: [
              getDictOptionsByValue(value, 'GENDER', 'gender'),
              getDictOptionsByValue(value, 'BRAND', 'brand'),
              getDictOptionsByValue(value, 'BILL_PAYMENTSTATUS', 'billPaymentstatus'),
            ].map((item) => DropDownMenuModel(
              fieldName: item.fieldName!,
              name: item.name ?? '',
              layerLink: LayerLink(),
              list: item.children?.map((e) => Option(check: false, dictLabel: e.dictLabel, dictValue: e.dictValue)).toList() ?? []
            )).toList(),
            provider: imageInventoryProvider,
            columns: [
              ListColumnModal(label: '模型类型', field: 'model'),
              ListColumnModal(label: '客户唯一索引', field: 'source'),
              ListColumnModal(label: '资源', field: 'input'),
              ListColumnModal(label: '识别数量', field: 'resultAmount'),
              ListColumnModal(label: '创建时间', field: 'createTime'),
            ],

          );
        }
      )
    );
  }
}