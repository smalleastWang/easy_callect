import 'package:easy_collect/api/insurance.dart';
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/enums/index.dart';
import 'package:easy_collect/utils/OverlayManager.dart';
import 'package:easy_collect/models/dropDownMenu/DropDownMenu.dart';
import 'package:easy_collect/views/precisionBreeding/data.dart';
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
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusSearchInputNode = FocusNode();

  Map<String, dynamic> _createRequestParams() {
    return {
      'policyNo': _searchController.text,
    };
  }

  void _onSearch() {
    if (listWidgetKey.currentState != null) {
      listWidgetKey.currentState!.getList(_createRequestParams());
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    overlayEntryAllRemove();
    _searchController.dispose();
    super.dispose();
  }

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
      body: GestureDetector(
        onTap: () {
          _focusSearchInputNode.unfocus();
        },
        child: Container(
          color: const Color(0xFFF1F5F9),
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
                  child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return TextField(
                        controller: _searchController,
                        focusNode: _focusSearchInputNode,
                        decoration: InputDecoration(
                          hintText: '请输入保单合同号',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: const Color(0xFFF5F7F9),
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_searchController.text.isNotEmpty)
                                IconButton(
                                  icon: const Icon(Icons.clear, color: Color(0xFF666666), size: 24.0),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {}); // Update the state to refresh the suffixIcon
                                    _onSearch();
                                  },
                                ),
                              TextButton(
                                onPressed: () => _onSearch(),
                                style: TextButton.styleFrom(
                                  backgroundColor: const Color(0xFF5D8FFD),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                  minimumSize: const Size(50.0, 40.0),
                                ),
                                child: const Text(
                                  '搜索',
                                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onChanged: (_) {
                          setState(() {}); // Update the state to refresh the suffixIcon
                        },
                        onSubmitted: (_) => _onSearch(),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: ListWidget<OrderListFamily>(
                  key: listWidgetKey,
                  provider: orderListProvider,
                  filterList: [
                    DropDownMenuModel(name: '保险状态', list: enumsStrValToOptions(PolicyStatus.values, true, false), layerLink: LayerLink(), fieldName: 'state', onTap: () => _focusSearchInputNode.unfocus()),
                    DropDownMenuModel(name: '保单创建时间', layerLink: LayerLink(), fieldName: 'createTime', widget: WidgetType.datePicker, onTap: () => _focusSearchInputNode.unfocus()),
                  ],
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
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Text(PolicyStatus.getLabel(data['state'].toString()), style: const TextStyle(color: Colors.white)),
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
                            OutlineActionButton(text: '绑定', onPressed: () => context.push(RouteEnum.insuranceDetailAdd.fullpath)),
                            const SizedBox(width: 10),
                            OutlineActionButton(text: '详情', onPressed: () {
                              context.push(RouteEnum.insuranceDetail.fullpath, extra: { 'id': data['id'] as String });
                            })
                          ],
                        )
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum PolicyState { pending, active, suspended, terminated }

extension PolicyStateExtension on PolicyState {
  String get name {
    switch (this) {
      case PolicyState.pending:
        return '待承保';
      case PolicyState.active:
        return '有效';
      case PolicyState.suspended:
        return '中止';
      case PolicyState.terminated:
        return '终止';
      default:
        return '';
    }
  }

  int get value {
    switch (this) {
      case PolicyState.pending:
        return 0;
      case PolicyState.active:
        return 1;
      case PolicyState.suspended:
        return 2;
      case PolicyState.terminated:
        return 3;
      default:
        return -1;
    }
  }

  static PolicyState fromValue(int value) {
    switch (value) {
      case 0:
        return PolicyState.pending;
      case 1:
        return PolicyState.active;
      case 2:
        return PolicyState.suspended;
      case 3:
        return PolicyState.terminated;
      default:
        return PolicyState.pending;
    }
  }
}
