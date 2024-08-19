import 'package:easy_collect/api/precisionBreeding.dart';
import 'package:easy_collect/enums/index.dart';
import 'package:easy_collect/utils/OverlayManager.dart';
import 'package:easy_collect/views/precisionBreeding/data.dart';
import 'package:easy_collect/widgets/List/ListCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_collect/api/intelligencewarn.dart';
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/models/dropDownMenu/DropDownMenu.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/widgets/List/index.dart';

class IntelligencewarnPage extends ConsumerStatefulWidget {
  const IntelligencewarnPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _IntelligencewarnPageState();
}

class _IntelligencewarnPageState extends ConsumerState<IntelligencewarnPage> {
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
        title: Text(RouteEnum.intelligencewarn.title),
      ),
      body: Container(
        color: const Color(0xFFF1F5F9),
        child: Column(
          children: [
            Expanded(
              child: weightInfoTree.when(
                data: (data) {
                  return ListWidget<IntelligencewarnPageFamily>(
                    pasture: PastureModel(
                      field: 'orgId',
                      options: data,
                    ),
                    provider: intelligencewarnPageProvider,
                    filterList: [
                      DropDownMenuModel(name: '牛耳标', layerLink: LayerLink(), fieldName: 'no', widget: WidgetType.input),
                      DropDownMenuModel(name: '预警类型', list: enumsStrValToOptions(WarnType.values, true), layerLink: LayerLink(), fieldName: 'warnType'),
                      DropDownMenuModel(name: '预警时间', layerLink: LayerLink(), fieldName: 'startDate,endDate', widget: WidgetType.dateRangePicker),
                    ],
                    builder: (rowData) {
                      return IntelligencewarnItem(rowData: rowData);
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

class IntelligencewarnItem extends StatelessWidget {
  final Map<String, dynamic> rowData;

  const IntelligencewarnItem({super.key, required this.rowData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF5D8FFD),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                rowData["warnTypeName"],
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              rowData["no"] ?? "未上传耳标号",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            // const Icon(Icons.chevron_right),
          ],
        ),
        ListCardCell(
          label: '牧场名称',
          value: rowData["orgName"],
        ),
        ListCardCellTime(
          label: '预警时间',
          value: rowData["createTime"],
        ),
      ],
    );
  }
}