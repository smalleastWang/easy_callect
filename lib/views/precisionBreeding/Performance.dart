import 'package:easy_collect/api/precisionBreeding.dart';
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ModuleListModel {
  RouteEnum route;
  Color background;
  ModuleListModel({required this.route, required this.background});
}

class PerformancePage extends ConsumerStatefulWidget {
  const PerformancePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PerformancePageState();
}

class _PerformancePageState extends ConsumerState<PerformancePage> {
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
    final AsyncValue<List<EnclosureModel>> weightInfoTree = ref.watch(weightInfoTreeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('体征信息'),
      ),
      body: Container(
        color: const Color(0xFFF1F5F9),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            const SizedBox(height: 6),
            Expanded(
              child: weightInfoTree.when(
                data: (data) {
                  return ListWidget<WeightInfoPageFamily>(
                    pasture: PastureModel(
                      field: 'orgId',
                      options: data,
                    ),
                    provider: weightInfoPageProvider,
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
  final rowData;

  const PerformanceItem({super.key, required this.rowData});

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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                // const Icon(Icons.chevron_right),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text('身长/CM     ${rowData["length"]}', style: const TextStyle(color: Color(0xFF666666))),
                ),
                Expanded(
                  child: Text('身高/CM     ${rowData["high"]}', style: const TextStyle(color: Color(0xFF666666))),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text('肩宽/CM     ${rowData["width"]}', style: const TextStyle(color: Color(0xFF666666))),
                ),
                Expanded(
                  child: Text('十字部高/CM     ${rowData["crossHigh"]}', style: const TextStyle(color: Color(0xFF666666))),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text('体斜长/CM     ${rowData["plag"]}', style: const TextStyle(color: Color(0xFF666666))),
                ),
                Expanded(
                  child: Text('胸围/CM     ${rowData["bust"]}', style: const TextStyle(color: Color(0xFF666666))),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text('腹围/CM     ${rowData["circum"]}', style: const TextStyle(color: Color(0xFF666666))),
                ),
                Expanded(
                  child: Text('管围/CM     ${rowData["canno"]}', style: const TextStyle(color: Color(0xFF666666))),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 0.5, color: Color(0xFFE2E2E2)),
            const SizedBox(height: 12),
            Text('测定日期: ${rowData["date"]}',
                style: const TextStyle(color: Color(0xFF999999))),
          ],
        ),
      ),
    );
  }
}