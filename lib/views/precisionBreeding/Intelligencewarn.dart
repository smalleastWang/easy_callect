import 'package:easy_collect/api/precisionBreeding.dart';
import 'package:easy_collect/enums/index.dart';
import 'package:easy_collect/views/precisionBreeding/data.dart';
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
                      DropDownMenuModel(name: '输入牛耳标', layerLink: LayerLink(), fieldName: 'state', widget: WidgetType.input),
                      DropDownMenuModel(name: '预警类型', list: enumsToOptions(WarnType.values, true), layerLink: LayerLink(), fieldName: 'warnType'),
                      DropDownMenuModel(name: '预警时间', layerLink: LayerLink(), fieldName: 'first,last', widget: WidgetType.dateRangePicker),
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
              rowData["no"],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            // const Icon(Icons.chevron_right),
          ],
        ),
        const SizedBox(height: 12),
        Text('牧场名称     ${rowData["orgName"]}', style: const TextStyle(color: Color(0xFF666666))),
        const SizedBox(height: 12),
        const Divider(height: 0.5, color: Color(0xFFE2E2E2)),
        const SizedBox(height: 12),
        Text('预警时间: ${rowData["createTime"]}', style: const TextStyle(color: Color(0xFF999999))),
      ],
    );
  }
}