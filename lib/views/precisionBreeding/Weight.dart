import 'package:easy_collect/api/precisionBreeding.dart';
import 'package:easy_collect/api/weight.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeightPage extends ConsumerStatefulWidget {
  const WeightPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WeightPageState();
}

class _WeightPageState extends ConsumerState<WeightPage> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<EnclosureModel>> weightInfoTree =
        ref.watch(weightInfoTreeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('体重信息'),
      ),
      body: Container(
        color: const Color(0xFFF1F5F9),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: weightInfoTree.when(
                data: (data) {
                  return ListWidget<WeightPageFamily>(
                    pasture: PastureModel(
                      field: 'orgId',
                      options: data,
                    ),
                    provider: weightPageProvider,
                    builder: (rowData) {
                      return WeightItem(rowData: rowData);
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

class WeightItem extends StatelessWidget {
  final rowData;

  const WeightItem({super.key, required this.rowData});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
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
                    '${rowData["dataValue"]}KG',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const Spacer(),
                const Icon(Icons.chevron_right),
              ],
            ),
            const SizedBox(height: 12),
            Text('牛耳标:   ${rowData["animalNo"] ?? '未知'}'),
            const SizedBox(height: 12),
            Text('与上一次的体重变化值:   ${rowData["changeWeight"] ?? '未知'}'),
            const SizedBox(height: 12),
            Text('日增重:   ${rowData["dailyGain"] ?? '未知'}'),
            const SizedBox(height: 12),
            const Divider(height: 0.5, color: Color(0xFFE2E2E2)),
            const SizedBox(height: 12),
            Text('测定日期:   ${rowData["date"] ?? '未知'}', style: const TextStyle(color: Color(0xFF999999))),
          ],
        ),
      ),
    );
  }
}
