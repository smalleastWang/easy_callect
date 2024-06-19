import 'package:easy_collect/api/health.dart';
import 'package:easy_collect/api/precisionBreeding.dart';
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/models/register/index.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: weightInfoTree.when(
                data: (data) {
                  return ListWidget<HealthPageFamily>(
                    pasture: PastureModel(
                      field: 'orgId',
                      options: data,
                    ),
                    provider: healthPageProvider,
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
  // ignore: prefer_typing_uninitialized_variables
  final rowData;

  const HealthCheckItem({super.key, required this.rowData});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      // color: Colors.white,
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
                  rowData["orgName"],
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                const Icon(Icons.chevron_right),
              ],
            ),
            const SizedBox(height: 12),
            Text('牛耳标:   ${rowData["no"]}'),
            const SizedBox(height: 12),
            Text(
                '唯一标识码:   ${rowData["algorithmCode"]}'), // Assuming the unique ID is the same as animalNo
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
