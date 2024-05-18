import 'dart:convert';

import 'package:easy_collect/api/precisionBreeding.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/views/precisionBreeding/data.dart';
import 'package:easy_collect/widgets/Form/SearchDate.dart';
import 'package:easy_collect/widgets/List/ListItem.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/api/inventory.dart';


class InventoryPage extends ConsumerStatefulWidget {
  const InventoryPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<ConsumerStatefulWidget> createState() => _InventoryPageState();
}

class _InventoryPageState extends ConsumerState<InventoryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  GlobalKey<ListWidgetState> imgWidgetKey = GlobalKey<ListWidgetState>();
  GlobalKey<ListWidgetState> regWidgetKey = GlobalKey<ListWidgetState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _startTimeController = TextEditingController();
    _endTimeController = TextEditingController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<EnclosureModel>> weightInfoTree = ref.watch(weightInfoTreeProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(RouteEnum.inventory.title),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '图像盘点'),
            Tab(text: '识别盘点'),
            Tab(text: '计数盘点'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildImageInventoryPage,
          _buildRegInventoryInfoPage(weightInfoTree),
          _buildCntInventoryInfoPage(weightInfoTree)
        ],
      ),
    );
  }
  // 图像盘点
  Widget get _buildImageInventoryPage {
    return ListWidget<ImageInventoryFamily>(
      key: imgWidgetKey,
      debugLabel: '11',
      searchForm: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: SearchDateWidget(
          hintText: '盘点时间',
          onChange: (String first, String last) {
            imgWidgetKey.currentState!.getList({'first': first, 'last': last});
          },
        )
      ),
      provider: imageInventoryProvider,
      builder: (data) {
          return ListItemWidget(
            rowData: data,
            columns: [
              ListColumnModal(label: '模型类型', field: 'orgName'),
              ListColumnModal(label: '客户唯一索引', field: 'source'),
              ListColumnModal(label: '资源', field: 'input'),
              ListColumnModal(label: '识别数量', field: 'result', render: (value, record, column) {
                return Text('${jsonDecode(value ?? '{}')?['total'] ?? 0}只');
              }),

              ListColumnModal(label: '算法返回结果', field: 'result', render: (value, record, column) {
                if (value == null) return const Text('-');
                final result = jsonDecode(value);
                if (result['imgurl'] == null) return const Text('-');
                if (record['model'] == 'cattle-img') {
                  return Image.network(result['imgurl'], width: 140, errorBuilder: (context, error, stackTrace) {
                    return const Text('图片加载错误');
                  });
                } else if (record['model'] == 'cattle-video') {
                  return const Text('视频');
                }
                return const Text('-');
              }),
              ListColumnModal(label: '创建时间', field: 'createTime'),
            ]
          );
        },
    );
  }
  // 识别盘点
  Widget _buildRegInventoryInfoPage(AsyncValue<List<EnclosureModel>> weightInfoTree) {
    return ListWidget<RegInventoryInfoPageFamily>(
      key: regWidgetKey,
      searchForm: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: SearchDateWidget(
          hintText: '盘点时间',
          onChange: (String first, String last) {
            regWidgetKey.currentState!.getList({'first': first, 'last': last});
          },
        )
      ),
      debugLabel: '22',
      pasture: PastureModel(
        field: 'orgId',
        options: weightInfoTree.value ?? []
      ),
      provider: regInventoryInfoPageProvider,
      builder: (data) {
          return ListItemWidget(
            rowData: data,
            columns: [
              ListColumnModal(label: '牧场简称', field: 'orgName'),
              ListColumnModal(label: '圈舍名称', field: 'buildingName'),
              ListColumnModal(label: '盘点时间', field: 'checkTime'),
              ListColumnModal(label: '盘点状态', field: 'state', render: (value, record, column) => Text(InventoryStatus.getLabel(value))),
              ListColumnModal(label: '实际数量', field: 'actualNum'),
              ListColumnModal(label: '授权牛数量', field: 'authNum'),
              ListColumnModal(label: '盘点总数量', field: 'inventoryNum'),
              ListColumnModal(label: '盘点授权牛总数量', field: 'inventoryTotalNum'),
              ListColumnModal(label: '匹配失败数量', field: 'inventoryFailNum'),
              ListColumnModal(label: '昨天盘点总数', field: 'lastInventoryAuthTotalNum'),
              ListColumnModal(label: '盘点人', field: 'stateName'),
            ]
          );
        },
    );
  }
  //计数盘点
  Widget _buildCntInventoryInfoPage(AsyncValue<List<EnclosureModel>> weightInfoTree) {
    return ListWidget<CntInventoryInfoPageFamily>(
      pasture: PastureModel(
        field: 'orgId',
        options: weightInfoTree.value ?? []
      ),
      provider: cntInventoryInfoPageProvider,
      builder: (data) {
          return ListItemWidget(
            rowData: data,
            columns: [
              ListColumnModal(label: '牧场简称', field: 'orgName'),
              ListColumnModal(label: '圈舍名称', field: 'buildingName'),
              ListColumnModal(label: '盘点时间', field: 'checkTime'),
              ListColumnModal(label: '盘点类型', field: 'type', render: (value, _, __) => Text(InventoryType.getLabel(value))),
              ListColumnModal(label: '盘点状态', field: 'state', render: (value, _, __) => Text(InventoryStatus.getLabel(value))),
              ListColumnModal(label: '盘点数量', field: 'actualNum'),
              ListColumnModal(label: '上次盘点时间', field: 'lastTime'),
              ListColumnModal(label: '上次盘点数量', field: 'lastNum'),
            ]
          );
        },
    );
  }

}