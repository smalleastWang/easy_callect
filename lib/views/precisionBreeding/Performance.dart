import 'package:easy_collect/models/dropDownMenu/DropDownMenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_collect/api/precisionBreeding.dart';
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:go_router/go_router.dart';
class ModuleListModel {
  final RouteEnum route;
  final Color background;
  ModuleListModel({required this.route, required this.background});
}

class PerformancePage extends ConsumerStatefulWidget {
  const PerformancePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PerformancePageState();
}

class _PerformancePageState extends ConsumerState<PerformancePage> {
  final List<ModuleListModel> moduleList = [
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
    final AsyncValue<List<EnclosureModel>> weightInfoTree = ref.watch(weightInfoTreeProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('体征信息'),
      ),
      body: Container(
        color: const Color(0xFFF1F5F9),
        child: Column(
          children: [
            Expanded(
              child: weightInfoTree.when(
                data: (data) {
                  return ListWidget<WeightInfoPageFamily>(
                    pasture: PastureModel(
                      field: 'orgId',
                      options: data,
                    ),
                    provider: weightInfoPageProvider,
                    filterList: [
                      DropDownMenuModel(name: '牛耳标', layerLink: LayerLink(), fieldName: 'no', widget: WidgetType.input),
                      DropDownMenuModel(name: '测定日期', layerLink: LayerLink(), fieldName: 'startDate,endDate', widget: WidgetType.dateRangePicker),
                    ],
                    builder: (data) {
                      return PerformanceItem(rowData: data);
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

class PerformanceItem extends StatelessWidget {
  final Map<String, dynamic> rowData;

  const PerformanceItem({super.key, required this.rowData});

  void _navigateToDetail(BuildContext context, String algorithmCode, String dataType) {
    context.push(
      RouteEnum.performanceDetail.path,
      extra: {'algorithmCode': algorithmCode, 'dataType': dataType},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 12),
        _buildInfoRows(context),
        const SizedBox(height: 12),
        const Divider(height: 0.5, color: Color(0xFFE2E2E2)),
        const SizedBox(height: 12),
        Text('测定日期: ${rowData["date"]}', style: const TextStyle(color: Color(0xFF999999))),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF5D8FFD),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            rowData["buildingName"],
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          rowData["animalNo"],
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildInfoRows(BuildContext context) {
    return Column(
      children: [
        _buildTwoColumns(context, '身长/CM', rowData["length"], '0', '身高/CM', rowData["high"], '2'),
        const SizedBox(height: 12),
        _buildTwoColumns(context, '肩宽/CM', rowData["width"], '4', '十字部高/CM', rowData["crossHigh"], '5'),
        const SizedBox(height: 12),
        _buildTwoColumns(context, '体斜长/CM', rowData["plag"], '6', '胸围/CM', rowData["bust"], '7'),
        const SizedBox(height: 12),
        _buildTwoColumns(context, '腹围/CM', rowData["circum"], '8', '管围/CM', rowData["canno"], '9'),
      ],
    );
  }

  Widget _buildTwoColumns(
    BuildContext context,
    String label1, dynamic value1, String dataType1,
    String label2, dynamic value2, String dataType2,
  ) {
    return Row(
      children: [
        Expanded(child: _buildInfoRow(context, label1, value1, rowData["algorithmCode"], dataType1)),
        Expanded(child: _buildInfoRow(context, label2, value2, rowData["algorithmCode"], dataType2)),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, dynamic value, String algorithmCode, String dataType) {
    return GestureDetector(
      onTap: () => _navigateToDetail(context, algorithmCode, dataType),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: label,
              style: const TextStyle(color: Color(0xFF3B81F2)),
            ),
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  value,
                  style: const TextStyle(color: Color(0xFF666666)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
