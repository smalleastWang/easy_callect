import 'package:easy_collect/api/insurance.dart';
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/enums/register.dart';
import 'package:easy_collect/widgets/List/ListCard.dart';
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
          return Column(
            children: [
              ListCardTitle(
                hasDetail: false,
                title: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: data['state'] == 1 ? const Color(0xFF5D8FFD) : const Color(0xFFCCCCCC),
                        borderRadius: BorderRadius.circular(3)
                      ),
                      child: Text(OrderStatus.getLabel(data['state']), style: const TextStyle(color: Colors.white)),
                    ),
                    Text(data['policyContent'], style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              ListCardCell(label: '保险合同号', value: data['policyNo']),
              ListCardCell(label: '保险费', value: data['premium'].toString()),
              ListCardCell(label: '联系人', value: data['person']),
              ListCardCell(label: '联系电话', value: data['phone']),
              ListCardCell(label: '合同生效日期', value: data['effectiveTime']),
              ListCardCell(label: '合同期满日期', value: data['expiryTime']),
              const SizedBox(height: 8),
              ListCardCellTime(label: '创建时间', value: data['createTime'])
            ],
          );
        },
      )
    );
  }
}