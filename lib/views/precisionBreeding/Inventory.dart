import 'dart:convert';

import 'package:easy_collect/api/precisionBreeding.dart';
import 'package:easy_collect/enums/register.dart';
import 'package:easy_collect/models/dropDownMenu/DropDownMenu.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/utils/OverlayManager.dart';
import 'package:easy_collect/utils/dialog.dart';
import 'package:easy_collect/views/precisionBreeding/data.dart';
import 'package:easy_collect/widgets/DropDownMenu/index.dart';
import 'package:easy_collect/widgets/Form/SearchDate.dart';
import 'package:easy_collect/widgets/Form/BottomSheetPicker.dart';
import 'package:easy_collect/widgets/List/ListCard.dart';
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
      searchForm: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: SearchDateWidget(
          hintText: '请选择盘点时间',
          onChange: (String first, String last) {
            imgWidgetKey.currentState!.getList({'first': first, 'last': last});
          },
        )
      ),
      provider: imageInventoryProvider,
      builder: (data) {
          return  Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white
            ),
            child: Column(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    showMyModalBottomSheet(
                      context: context,
                      title: '详情信息',
                      contentBuilder: (BuildContext context) {
                        resultRender() {
                          if (data['result'] == null) return const Text('-');
                          final result = jsonDecode(data['result']);
                          if (result['imgurl'] == null) return const Text('-');
                          if (data['model'] == 'cattle-img') {
                            return Image.network(result['imgurl'], width: 140, errorBuilder: (context, error, stackTrace) {
                              return const Text('图片加载错误');
                            });
                          } else if (data['model'] == 'cattle-video') {
                            return const Text('视频');
                          }
                          return const Text('-');
                        }
                        
                        return Column(
                          children: [
                            Row(
                              children: [
                                const SizedBox(
                                  width: 100,
                                  child: Text('模型类型', style: TextStyle(color: Color(0xFF666666))),
                                ),
                                Text(CountMediaEnum.getLabel(data['model']))
                              ],
                            ),
                            const SizedBox(height: 10),
                             Row(
                              children: [
                                const SizedBox(
                                  width: 100,
                                  child: Text('用户名称', style: TextStyle(color: Color(0xFF666666))),
                                ),
                                Text(data['name'])
                              ],
                            ),
                            const SizedBox(height: 10),
                             Row(
                              children: [
                                const SizedBox(
                                  width: 100,
                                  child: Text('用户账号', style: TextStyle(color: Color(0xFF666666))),
                                ),
                                Text(data['account'])
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 100,
                                  child: Text('客户唯一索引', style: TextStyle(color: Color(0xFF666666))),
                                ),
                                Text(data['source'] ?? '-')
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 100,
                                  child: Text('识别数量', style: TextStyle(color: Color(0xFF666666))),
                                ),
                                Text('${jsonDecode(data['result'] ?? '{}')?['total'] ?? 0}只'),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 100,
                                  child: Text('算法返回结果', style: TextStyle(color: Color(0xFF666666))),
                                ),
                                resultRender()
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Text('创建时间：', style: TextStyle(color: Color(0xFF999999))),
                                Text(data['createTime'] ?? '-', style: const TextStyle(color: Color(0xFF999999))),
                              ],
                            )
                          ],
                        );
                      }
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(CountMediaEnum.getLabel(data['model']), style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500)),
                        const Icon(Icons.arrow_forward_ios, color: Color(0xff888888), size: 16)
                      ],
                    ),
                  ),
                ),
                ListCardCell(label: '用户名称', value: data['name']),
                ListCardCell(label: '用户账号', value: data['account']),
                // ListCardCell(label: '客户唯一索引', value: data['source']),
                ListCardCell(label: '识别数量', value: '${jsonDecode(data['result'] ?? '{}')?['total'] ?? 0}只'),
                ListCardCellTime(label: '盘点时间：', value: data['createTime'])
              ],
              
            ),
          );
        },
    );
  }
  // 识别盘点
  Widget _buildRegInventoryInfoPage(AsyncValue<List<EnclosureModel>> weightInfoTree) {
    return ListWidget<RegInventoryInfoPageFamily>(
      key: regWidgetKey,
      filterList: [
        DropDownMenuModel(name: '选择状态', list: [
          Option(check: false, dictLabel: '不限', dictValue: ''),
          Option(check: false, dictLabel: '盘点中', dictValue: '0'),
          Option(check: false, dictLabel: '盘点结束', dictValue: '1'),
        ], layerLink: LayerLink(), fieldName: 'state'),
        DropDownMenuModel(name: '选择盘点时间', layerLink: LayerLink(), fieldName: 'first,last', widget: WidgetType.dateRangePicker),
      ],
      // searchForm: Container(
      //   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      //   child: Column(
      //   children: [
      //     BottomSheetPickerWidget(
      //       hintText: '请选择盘点状态',
      //       options: const [
      //         {'': '不限'},
      //         {'0': '盘点中'},
      //         {'1': '盘点结束'},
      //       ],
      //       onSelect: (option) {
      //         // Handle the selected option
      //         print('Selected option: $option');
      //         final key = option.keys.first;
      //         final value = option[key];
      //         print('Selected key: $key, value: $value');
      //         regWidgetKey.currentState!.getList({'state': key});
      //       },
      //     ),
      //     const SizedBox(height: 10), // Add some space between the widgets
      //     SearchDateWidget(
      //       hintText: '请选择盘点时间',
      //       onChange: (String first, String last) {
      //         print('Selected first: $first, last: $last');
      //         regWidgetKey.currentState!.getList({'first': first, 'last': last});
      //       },
      //     ),
      //   ],
      //   )
      // ),
      pasture: PastureModel(
        field: 'orgId',
        options: weightInfoTree.value ?? []
      ),
      provider: regInventoryInfoPageProvider,
      builder: (data) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white
          ),
          child: Column(
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
                      child: Text(InventoryStatus.getLabel(data['state']), style: const TextStyle(color: Colors.white)),
                    ),
                    Text(data['buildingName'], style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              ListCardCell(label: '盘点总数量', value: data['inventoryTotalNum']),
              ListCardCell(label: '昨天盘点总数量', value: data['lastInventoryTotalNum']),
              ListCardCell(label: '盘点人', value: data['createUser']),
              ListCardCellTime(label: '盘点时间：', value: data['checkTime'])
            ],
          ),
        );
      },
    );
  }
  //计数盘点
  Widget _buildCntInventoryInfoPage(AsyncValue<List<EnclosureModel>> weightInfoTree) {
    return ListWidget<CntInventoryInfoPageFamily>(
      key: cntWidgetKey,
      searchForm: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Column(
        children: [
          BottomSheetPickerWidget(
            hintText: '请选择盘点状态',
            options: const [
              {'': '不限'},
              {'0': '盘点中'},
              {'1': '盘点结束'},
            ],
            onSelect: (option) {
              // Handle the selected option
              print('Selected option: $option');
              final key = option.keys.first;
              final value = option[key];
              print('Selected key: $key, value: $value');
              cntWidgetKey.currentState!.getList({'state': key});
            },
          ),
          const SizedBox(height: 10), // Add some space between the widgets
          SearchDateWidget(
            hintText: '请选择盘点时间',
            onChange: (String first, String last) {
              print('Selected first: $first, last: $last');
              cntWidgetKey.currentState!.getList({'first': first, 'last': last});
            },
          ),
        ],
        )
      ),
      pasture: PastureModel(
        field: 'orgId',
        options: weightInfoTree.value ?? []
      ),
      provider: cntInventoryInfoPageProvider,
      builder: (data) {
          return Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white
          ),
          child: Column(
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
                      child: Text(InventoryStatus.getLabel(data['state']), style: const TextStyle(color: Colors.white)),
                    ),
                    Text(data['buildingName'], style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              ListCardCell(label: '盘点类型', value: data['typeName']),
              ListCardCell(label: '盘点数量', value: data['actualNum']),
              ListCardCell(label: '上次盘点数量', value: data['lastNum']),
              ListCardCell(label: '盘点人', value: data['createUser']),
              ListCardCell(label: '上次盘点时间', value: data['lastTime']),
              ListCardCellTime(label: '盘点时间：', value: data['checkTime'])
            ],
          ),
        );
        },
    );
  }

}