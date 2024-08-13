import 'package:easy_collect/enums/index.dart';
import 'package:easy_collect/enums/route.dart';
import 'package:easy_collect/models/dropDownMenu/DropDownMenu.dart';
import 'package:easy_collect/utils/OverlayManager.dart';
import 'package:easy_collect/views/precisionBreeding/data.dart';
import 'package:easy_collect/widgets/List/ListCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/api/precisionBreeding.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:easy_collect/api/aibox.dart';
import 'package:go_router/go_router.dart';

class AIBoxPage extends ConsumerStatefulWidget {
  const AIBoxPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AIBoxPageState();
}

class _AIBoxPageState extends ConsumerState<AIBoxPage> {
  final GlobalKey<ListWidgetState> listWidgetKey = GlobalKey<ListWidgetState>();

   void _navigateTo(String path) async {
    bool? result = await context.push(path);
    // 如果返回结果为true，则刷新列表
    if (result == true) {
      listWidgetKey.currentState?.refreshWithPreviousParams();
    }
  }

  void _addAiBox() {
    _navigateTo(RouteEnum.editAiBox.path);
  }

   @override
  void dispose() {
    overlayEntryAllRemove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<EnclosureModel>> weightInfoTree = ref.watch(weightInfoTreeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI盒子'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addAiBox,
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFFF1F5F9),
        child: Column(
          children: [
            Expanded(
              child: weightInfoTree.when(
                data: (data) {
                  return ListWidget<AiboxPageFamily>(
                    key: listWidgetKey,
                    pasture: PastureModel(
                      field: 'orgId',
                      options: data,
                    ),
                    provider: aiboxPageProvider,
                    filterList: [
                      DropDownMenuModel(name: '设备编号', layerLink: LayerLink(), fieldName: 'boxNo', widget: WidgetType.input),
                      DropDownMenuModel(name: '在线状态', list:  enumsStrValToOptions(OnlineStatusEnum.values, true, false), layerLink: LayerLink(), fieldName: 'online'),
                    ],
                    builder: (rowData) {
                      return AIBoxItem(rowData: rowData);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('加载数据时出错: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AIBoxItem extends StatelessWidget {
  final Map<String, dynamic> rowData;

  const AIBoxItem({super.key, required this.rowData});

  @override
  Widget build(BuildContext context) {
    String onlineStatus = rowData["online"] == "1" ? "在线" : "离线";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: rowData["online"] == "1" ? const Color(0xFF5D8FFD) : const Color(0xFFCCCCCC),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                onlineStatus,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              rowData["name"],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
          ],
        ),
        ListCardCell(
          label: '设备编号',
          value: rowData["boxNo"],
        ),
        ListCardCell(
          label: '牧场',
          value: rowData["orgName"],
        ),
        ListCardCell(
          label: '圈舍',
          value: rowData["buildingName"],
        ),
        ListCardCellTime(
          label: '创建时间',
          value: rowData["createTime"],
        ),
      ],
    );
  }
}