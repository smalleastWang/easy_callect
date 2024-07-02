import 'package:easy_collect/api/health.dart';
import 'package:easy_collect/api/precisionBreeding.dart';
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/models/dropDownMenu/DropDownMenu.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/widgets/DropDownMenu/index.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HealthCheckPage extends ConsumerStatefulWidget {
  const HealthCheckPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HealthCheckPageState();
}

class _HealthCheckPageState extends ConsumerState<HealthCheckPage> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<EnclosureModel>> weightInfoTree =
        ref.watch(weightInfoTreeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(RouteEnum.healthCheck.title),
      ),
      body: Container(
        color: const Color(0xFFF1F5F9),
        child: Column(
          children: [
            const SizedBox(height: 6),
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
                      DropDownMenuModel(name: '输入牛耳标', layerLink: LayerLink(), fieldName: 'state', widget: WidgetType.input),
                      DropDownMenuModel(name: '健康检测类型', list: [
                        Option(check: false, dictLabel: '不限', dictValue: ''),
                        Option(check: false, dictLabel: '盘点中', dictValue: '0'),
                        Option(check: false, dictLabel: '盘点结束', dictValue: '1'),
                      ], layerLink: LayerLink(), fieldName: 'state'),
                      DropDownMenuModel(name: '检测时间', layerLink: LayerLink(), fieldName: 'first,last', widget: WidgetType.dateRangePicker),
                    ],
                    builder: (rowData) {
                      return HealthCheckItem(rowData: rowData);
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

class HealthCheckItem extends StatelessWidget {
  final Map<String, dynamic> rowData;

  const HealthCheckItem({super.key, required this.rowData});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
            const SizedBox(height: 12),
            Text('牧场名称     ${rowData["orgName"]}', style: const TextStyle(color: Color(0xFF666666))),
            const SizedBox(height: 12),
            const Divider(height: 0.5, color: Color(0xFFE2E2E2)),
            const SizedBox(height: 12),
            Text('检测时间: ${rowData["createTime"]}',
                style: const TextStyle(color: Color(0xFF999999))),
          ],
        ),
      ),
    );
  }
}