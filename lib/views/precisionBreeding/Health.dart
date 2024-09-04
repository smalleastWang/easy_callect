import 'package:easy_collect/api/health.dart';
import 'package:easy_collect/api/precisionBreeding.dart';
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/enums/index.dart';
import 'package:easy_collect/models/dropDownMenu/DropDownMenu.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/utils/OverlayManager.dart';
import 'package:easy_collect/views/precisionBreeding/data.dart';
import 'package:easy_collect/widgets/List/ListCard.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HealthPage extends ConsumerStatefulWidget {
  const HealthPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HealthPageState();
}

class _HealthPageState extends ConsumerState<HealthPage> {
  @override
  void dispose() {
    overlayEntryAllRemove();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<EnclosureModel>> weightInfoTree =
        ref.watch(weightInfoTreeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(RouteEnum.health.title),
      ),
      body: Container(
        color: const Color(0xFFF1F5F9),
        child: Column(
          children: [
            Expanded(
              child: weightInfoTree.when(
                data: (data) {
                  return ListWidget<HealthPageFamily>(
                    pasture: PastureModel(
                      field: 'orgId',
                      options: data,
                    ),
                    provider: healthPageProvider,
                    filterList: [
                      DropDownMenuModel(name: '牛耳标', layerLink: LayerLink(), fieldName: 'no', widget: WidgetType.input),
                      DropDownMenuModel(name: '检测类型', list:  enumsStrValToOptions(PostureType.values, true, false), layerLink: LayerLink(), fieldName: 'health'),
                      DropDownMenuModel(name: '检测时间', layerLink: LayerLink(), fieldName: 'startDate,endDate', widget: WidgetType.dateRangePicker),
                    ],
                    builder: (rowData) {
                      return HealthItem(rowData: rowData);
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

class HealthItem extends StatelessWidget {
  final Map<String, dynamic> rowData;

  const HealthItem({super.key, required this.rowData});

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
                rowData["postureName"],
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              rowData["no"],
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
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
          label: '检测时间',
          value: rowData["createTime"],
        ),
      ],
    );
  }
}