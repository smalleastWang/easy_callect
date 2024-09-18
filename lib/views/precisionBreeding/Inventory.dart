import 'dart:convert';

import 'package:easy_collect/api/precisionBreeding.dart';
import 'package:easy_collect/enums/index.dart';
import 'package:easy_collect/enums/register.dart';
import 'package:easy_collect/models/dropDownMenu/DropDownMenu.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/utils/OverlayManager.dart';
import 'package:easy_collect/utils/colors.dart';
import 'package:easy_collect/views/precisionBreeding/data.dart';
import 'package:easy_collect/views/precisionBreeding/inventory/InventoryCntDetail.dart';
import 'package:easy_collect/views/precisionBreeding/inventory/InventoryTotalAnimal.dart';
import 'package:easy_collect/views/precisionBreeding/inventory/manual.dart';
import 'package:easy_collect/widgets/Button/PrimaryActionButton.dart';
import 'package:easy_collect/widgets/List/ListCard.dart';
import 'package:easy_collect/widgets/List/ListCardTitleCell.dart';
import 'package:easy_collect/widgets/List/ListItem.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/api/inventory.dart';
import 'package:go_router/go_router.dart';

enum MoreAction {
  totalnum(1, '盘点总数'),
  failNUm(2, '匹配失败数');
  final int value;
  final String label;

  const MoreAction(this.value, this.label);

}

class InventoryPage extends ConsumerStatefulWidget {
  const InventoryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InventoryPageState();
}

class _InventoryPageState extends ConsumerState<InventoryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int currentIndex = 0;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  GlobalKey<ListWidgetState> imgWidgetKey = GlobalKey<ListWidgetState>();
  GlobalKey<ListWidgetState> regWidgetKey = GlobalKey<ListWidgetState>();
  GlobalKey<ListWidgetState> cntWidgetKey = GlobalKey<ListWidgetState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _startTimeController = TextEditingController();
    _endTimeController = TextEditingController();
    _tabController.addListener(() {
      overlayEntryAllRemove();
    });
  }

  @override
  void dispose() {
    overlayEntryAllRemove();
    _tabController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<EnclosureModel>> weightInfoTree = ref.watch(weightInfoTreeProvider);
    _tabController.index;
    return Scaffold(
      appBar: AppBar(
        title: Text(RouteEnum.inventory.title),
        actions: currentIndex == 0 ? [
          InkWell(
            onTap: () => context.push(RouteEnum.countRegister.fullpath),
            child: const Icon(Icons.add, color: MyColors.primaryColor, size: 30),
          )
        ] : null,
        bottom: TabBar(
          controller: _tabController,
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
          },
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
          _buildImageInventoryPage(weightInfoTree),
          _buildRegInventoryInfoPage(weightInfoTree),
          _buildCntInventoryInfoPage(weightInfoTree)
        ],
      ),
    );
  }
  Widget _imgRender(value, record, column) {
    if (value == null) return const Text('-');
    final result = jsonDecode(value);
    if (result['imgurl'] == null) return const Text('-');
    if (record['model'] == CountMediaEnum.img.value) {
      return Image.network(result['imgurl'], width: 140, errorBuilder: (context, error, stackTrace) {
        return const Text('图片加载错误');
      });
    } else if (record['model'] == CountMediaEnum.video.value) {
      return const Text('视频');
    }
    return const Text('-');
  }

  // 图像盘点
  Widget _buildImageInventoryPage(AsyncValue<List<EnclosureModel>> weightInfoTree) {
    return ListWidget<ImageInventoryFamily>(
      key: imgWidgetKey,
      filterList: [
        DropDownMenuModel(name: '模型类型', 
        list: enumsStrValToOptions(CountMediaEnum.values, true, false),
        layerLink: LayerLink(), fieldName: 'model'),
        DropDownMenuModel(name: '选择盘点时间', layerLink: LayerLink(), fieldName: 'first,last', widget: WidgetType.dateRangePicker),
      ],
      provider: imageInventoryProvider,
      builder: (data) {
          return  Column(
            children: [
              ListCardTitleCell(
                rowData: data,
                title: CountMediaEnum.getLabel(data['model']),
                detailColumns: [
                  ListColumnModal(field: 'model', label: '模型类型', render: (value, record, column) => Text(CountMediaEnum.getLabel(value))),
                  ListColumnModal(field: 'name', label: '用户名称'),
                  ListColumnModal(field: 'account', label: '用户账号'),
                  ListColumnModal(field: 'source', label: '客户唯一索引'),
                  ListColumnModal(field: 'result', label: '识别数量', render: (value, record, column) => Text('${jsonDecode(value ?? '{}')?['total'] ?? 0}只')),
                  ListColumnModal(field: 'result', label: '算法返回结果', render: _imgRender),
                  ListColumnModal(field: 'createTime', label: '创建时间：'),
                ],
              ),
              ListCardCell(label: '用户名称', value: data['name']),
              ListCardCell(label: '用户账号', value: data['account']),
              // ListCardCell(label: '客户唯一索引', value: data['source']),
              ListCardCell(label: '识别数量', value: '${jsonDecode(data['result'] ?? '{}')?['total'] ?? 0}只'),
              ListCardCellTime(label: '创建时间', value: data['createTime'])
            ],
          );
        },
    );
  }
  // 识别盘点
  Widget _buildRegInventoryInfoPage(AsyncValue<List<EnclosureModel>> weightInfoTree) {
    return ListWidget<RegInventoryInfoPageFamily>(
      key: regWidgetKey,
      filterList: [
        DropDownMenuModel(name: '选择状态', list: enumsStrValToOptions(InventoryStatus.values, true, false), layerLink: LayerLink(), fieldName: 'state'),
        DropDownMenuModel(name: '选择盘点时间', layerLink: LayerLink(), fieldName: 'first,last', widget: WidgetType.dateRangePicker),
      ],
      pasture: PastureModel(
        field: 'orgId',
        options: weightInfoTree.value ?? []
      ),
      provider: regInventoryInfoPageProvider,
      builder: (data) {
        return Column(
          children: [
            ListCardTitleCell(
              state: ListCardTitleStateModal(text: InventoryStatus.getLabel(data['state'].toString())),
              rowData: data,
              title: data['buildingName'],
              detailLabelWidth: 120,
              detailColumns: [
                ListColumnModal(field: 'orgName', label: '牧场名称'),
                ListColumnModal(field: 'buildingName', label: '圈舍名称'),
                ListColumnModal(field: 'checkTime', label: '盘点时间'),
                ListColumnModal(field: 'state', label: '盘点状态', render: (value, record, column) => Text(InventoryStatus.getLabel(value))),
                ListColumnModal(field: 'actualNum', label: '实际数量'),
                ListColumnModal(field: 'authNum', label: '授权牛数量'),
                ListColumnModal(field: 'inventoryTotalNum', label: '盘点总数量'),
                ListColumnModal(field: 'inventoryAuthNum', label: '盘点授权牛总数量'),
                ListColumnModal(field: 'inventoryFailNum', label: '匹配失败数量'),
                ListColumnModal(field: 'lastInventoryTotalNum', label: '昨天盘点总数'),
                ListColumnModal(field: 'createUser', label: '盘点人'),
              ],
            ),
            ListCardCell(label: '盘点人', value: data['createUser']),
            ListCardCell(label: '盘点总数', value: data['inventoryTotalNum']),
            ListCardCell(label: '昨天盘点总数', value: data['lastInventoryTotalNum']),
            ListCardCell(label: '盘点时间', value: data['checkTime']),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PrimaryActionButton(text: '设置盘点时间', onPressed: () => context.go(RouteEnum.inventorySetTime.fullpath)),
                OutlineActionButton(text: '设置上传时间', onPressed: () => context.go(RouteEnum.inventorySetUploadTime.fullpath)),
                OutlineActionButton(text: '历史数据', onPressed: () {
                  context.go(RouteEnum.inventoryHistoryData.fullpath, extra: { 'buildingId': data['buildingId'] as String });
                }),
                MoreActionWidget(
                  onSelected: (value) {
                    print(value);
                    if(value == 0) {
                       Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InventoryTotalAnimalPage(buildingId: data['buildingId'], inventoryId: data['inventoryId']),
                        ),
                      );
                    }
                    if(value == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InventoryTotalAnimalPage(buildingId: data['buildingId'], inventoryId: data['inventoryId']),
                        ),
                      );
                    }
                  },
                  items: MoreAction.values.map((e) => PopupMenuItem(
                    value: e.value,
                    height: 32,
                    child:Text(e.label),
                  )).toList()
                )
              ],
            )
          ],
        );
      },
    );
  }
  //计数盘点
  Widget _buildCntInventoryInfoPage(AsyncValue<List<EnclosureModel>> weightInfoTree) {
    return Column(
      children: [
        Expanded(
          child: ListWidget<CntInventoryInfoPageFamily>(
            key: cntWidgetKey,
            filterList: [
              DropDownMenuModel(name: '选择状态', list: enumsStrValToOptions(InventoryStatus.values, true, false), layerLink: LayerLink(), fieldName: 'state'),
              DropDownMenuModel(name: '选择盘点时间', layerLink: LayerLink(), fieldName: 'first,last', widget: WidgetType.dateRangePicker),
            ],
            pasture: PastureModel(
              field: 'orgId',
              options: weightInfoTree.value ?? []
            ),
            provider: cntInventoryInfoPageProvider,
            builder: (data) {
              return Column(
                children: [
                  ListCardTitle(
                    title: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFCCD2E1),
                            borderRadius: BorderRadius.circular(3)
                          ),
                          child: Text(InventoryStatus.getLabel(data['state'].toString()), style: const TextStyle(color: Colors.white)),
                        ),
                        Text(data['buildingName'], style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    hasDetail: true,
                    onTap:() => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InventoryCntDetailPage(buildingId: data['buildingId'], taskId: data['inventoryId']),
                        ),
                      )
                    },
                  ),
                  ListCardCell(label: '盘点类型', value: data['typeName']),
                  ListCardCell(label: '盘点数量', value: data['actualNum']),
                  ListCardCell(label: '上次盘点数量', value: data['lastNum']),
                  ListCardCell(label: '盘点人', value: data['createUser']),
                  ListCardCell(label: '上次盘点时间', value: data['lastTime']),
                  ListCardCell(label: '盘点时间', value: data['checkTime']),
                  const SizedBox(height: 8),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     PrimaryActionButton(text: '详情', onPressed: () => {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => InventoryCntDetailPage(buildingId: data['buildingId'], taskId: data['inventoryId']),
                  //         ),
                  //       )
                  //     }),
                  //     const SizedBox(width: 10),
                  //     OutlineActionButton(text: '手工盘点', onPressed: () => {}),
                  //   ],
                  // )
                ],
              );
            },
          ),
        ),
        // 在页面底部添加手工盘点按钮
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: PrimaryActionButton(
            text: '手工盘点',
            onPressed: () {
              // 手工盘点按钮的功能
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ManualPage(),
                ),
              );
            },
          ),
        ),
      ],
    );
    }
}