import 'package:easy_collect/api/insurance.dart';
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/views/insurance/data.dart';
import 'package:easy_collect/widgets/List/ListItem.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ModuleListModel {
  RouteEnum route;
  Color background;
  ModuleListModel({required this.route, required this.background});
}

class OrderListPage extends ConsumerStatefulWidget {
  const OrderListPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrderListPageState();
}

class _OrderListPageState extends ConsumerState<OrderListPage> {
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
        title: Text(RouteEnum.orderList.title),
      ),
      body: ListWidget<OrderListFamily>(
        provider: orderListProvider,
        builder: (data) {
          return ListItemWidget(
            rowData: data,
            columns: [
              ListColumnModal(label: '组织名称', field: 'orgName'),
              ListColumnModal(label: '保险合同号', field: 'policyNo'),
              ListColumnModal(label: '保险项目', field: 'policyContent'),
              ListColumnModal(label: '保险费', field: 'premium'),
              ListColumnModal(label: '保险合同生效日期', field: 'effectiveTime'),
              ListColumnModal(label: '保险合同期满日期', field: 'expiryTime'),
              ListColumnModal(label: '保单创建时间', field: 'createTime'),
              ListColumnModal(label: '保单状态', field: 'state', render: (value, record, column) => Text(OrderStatus.getLabel(value))),
              ListColumnModal(label: '联系人', field: 'person'),
              ListColumnModal(label: '联系电话', field: 'phone'),
            ]
          );
        },
      )
    );
  }
}