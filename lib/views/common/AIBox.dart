import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/api/precisionBreeding.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:easy_collect/api/aibox.dart';

class AIBoxPage extends ConsumerStatefulWidget {
  const AIBoxPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AIBoxPageState();
}

class _AIBoxPageState extends ConsumerState<AIBoxPage> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<EnclosureModel>> weightInfoTree = ref.watch(weightInfoTreeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI盒子'),
      ),
      body: Container(
        color: const Color(0xFFF1F5F9),
        child: Column(
          children: [
            const SizedBox(height: 6),
            Expanded(
              child: weightInfoTree.when(
                data: (data) {
                  return ListWidget<AiboxPageFamily>(
                    pasture: PastureModel(
                      field: 'orgId',
                      options: data,
                    ),
                    provider: aiboxPageProvider,
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
        const SizedBox(height: 12),
        Text('设备编号     ${rowData["boxNo"] == null || rowData["boxNo"] == "" ? '未知' : rowData["boxNo"]}',
            style: const TextStyle(color: Color(0xFF666666))),
        const SizedBox(height: 12),
        Text('牧场     ${rowData["orgName"] == null || rowData["orgName"] == "" ? '未知' : rowData["orgName"]}',
            style: const TextStyle(color: Color(0xFF666666))),
        const SizedBox(height: 12),
        Text('圈舍     ${rowData["buildingName"] == null || rowData["buildingName"] == "" ? '未知' : rowData["buildingName"]}',
            style: const TextStyle(color: Color(0xFF666666))),
        const SizedBox(height: 12),
        const Divider(height: 0.5, color: Color(0xFFE2E2E2)),
        const SizedBox(height: 12),
        Text('创建时间: ${rowData["createTime"]}',
            style: const TextStyle(color: Color(0xFF999999))),
      ],
    );
  }
}