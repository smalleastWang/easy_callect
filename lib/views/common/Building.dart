import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/api/precisionBreeding.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:easy_collect/api/building.dart';

class BuildingPage extends ConsumerStatefulWidget {
  const BuildingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BuildingPageState();
}

class _BuildingPageState extends ConsumerState<BuildingPage> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<EnclosureModel>> weightInfoTree = ref.watch(weightInfoTreeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('圈舍信息'),
      ),
      body: Container(
        color: const Color(0xFFF1F5F9),
        child: Column(
          children: [
            const SizedBox(height: 6),
            Expanded(
              child: weightInfoTree.when(
                data: (data) {
                  return ListWidget<BuildingPageFamily>(
                    pasture: PastureModel(
                      field: 'orgId',
                      options: data,
                    ),
                    provider: buildingPageProvider,
                    builder: (rowData) {
                      return BuildingItem(rowData: rowData);
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

class BuildingItem extends StatelessWidget {
  final Map<String, dynamic> rowData;

  const BuildingItem({super.key, required this.rowData});

  @override
  Widget build(BuildContext context) {
    String onlineStatus = rowData["state"] == "0" ? "启用" : "禁用";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: rowData["state"] == "0" ? const Color(0xFF5D8FFD) : const Color(0xFFCCCCCC),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                onlineStatus,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              rowData["buildingName"],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 12),
        Text('牧场     ${rowData["orgName"] == null || rowData["orgName"] == "" ? '未知' : rowData["orgName"]}',
            style: const TextStyle(color: Color(0xFF666666))),
        const SizedBox(height: 12),
        Text('期初数量     ${rowData["maxNum"] == null || rowData["maxNum"] == "" ? '未知' : rowData["maxNum"]}',
            style: const TextStyle(color: Color(0xFF666666))),
        const SizedBox(height: 12),
        Text('当前牛数量     ${rowData["currentNum"] == null || rowData["currentNum"] == "" ? '未知' : rowData["currentNum"]}',
            style: const TextStyle(color: Color(0xFF666666))),
        const SizedBox(height: 12),
        Text('栋别     ${rowData["blockNum"] == null || rowData["blockNum"] == "" ? '未知' : rowData["blockNum"]}',
          style: const TextStyle(color: Color(0xFF666666))),
        const SizedBox(height: 12),
        Text('栏别     ${rowData["hurdleNum"] == null || rowData["hurdleNum"] == "" ? '未知' : rowData["hurdleNum"]}',
          style: const TextStyle(color: Color(0xFF666666))),
        // const SizedBox(height: 12),
        // const Divider(height: 0.5, color: Color(0xFFE2E2E2)),
        // const SizedBox(height: 12),
        // Text('创建时间: ${rowData["createTime"]}',
        //     style: const TextStyle(color: Color(0xFF999999))),
      ],
    );
  }
}