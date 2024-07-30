import 'package:easy_collect/api/insurance.dart';
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/enums/register.dart';
import 'package:easy_collect/widgets/Button/PrimaryActionButton.dart';
import 'package:easy_collect/widgets/List/ListCard.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
  final GlobalKey<ListWidgetState> listWidgetKey = GlobalKey<ListWidgetState>();

  void _navigateTo(String path) async {
    bool? result = await context.push(path);
    // 如果返回结果为true，则刷新列表
    if (result == true) {
      listWidgetKey.currentState?.refreshWithPreviousParams();
    }
  }

  void _addPolicy() {
    _navigateTo(RouteEnum.editPolicy.path);
  }

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
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addPolicy,
          ),
        ],
      ),
      body: ListWidget<OrderListFamily>(
        key: listWidgetKey,
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
              ListCardCell(label: '创建时间', value: data['createTime']),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  PrimaryActionButton(text: '修改', onPressed: () => context.push(RouteEnum.editPolicy.fullpath, extra: data)),
                  const SizedBox(width: 10),
                  OutlineActionButton(text: '绑定', onPressed: () => context.push(RouteEnum.inventorySetUploadTime.fullpath)),
                  const SizedBox(width: 10),
                  OutlineActionButton(text: '详情', onPressed: () {
                    context.push(RouteEnum.insuranceDetail.fullpath, extra: { 'id': data['id'] as String });
                  })
                ],
              )
            ],
          );
        },
      )
    );
  }
}