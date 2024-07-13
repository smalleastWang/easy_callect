import 'package:easy_collect/enums/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/api/precisionBreeding.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:easy_collect/api/aibox.dart';
import 'package:go_router/go_router.dart';

class AIBoxPage extends ConsumerStatefulWidget {
  const AIBoxPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AIBoxPageState();
}

class _AIBoxPageState extends ConsumerState<AIBoxPage> {
  final GlobalKey<ListWidgetState> listWidgetKey = GlobalKey<ListWidgetState>();

   void _navigateTo(String path) async {
    bool? result = await context.push(path);
    // 如果返回结果为true，则刷新列表
    if (result == true) {
      listWidgetKey.currentState?.refreshWithPreviousParams();
    }
  }

  void _addAiBox() {
    _navigateTo(RouteEnum.editAiBox.path);
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<EnclosureModel>> weightInfoTree = ref.watch(weightInfoTreeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI盒子'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addAiBox,
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFFF1F5F9),
        child: Column(
          children: [
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
        _buildInfoRow('设备编号', rowData["boxNo"]),
        _buildInfoRow('牧场', rowData["orgName"]),
        _buildInfoRow('圈舍', rowData["buildingName"]),
        const SizedBox(height: 12),
        const Divider(height: 0.5, color: Color(0xFFE2E2E2)),
        const SizedBox(height: 12),
        Text('创建时间: ${rowData["createTime"]}',
            style: const TextStyle(color: Color(0xFF999999))),
      ],
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        '$label     ${value == null || value.isEmpty ? '未知' : value}',
        style: const TextStyle(color: Color(0xFF666666)),
      ),
    );
  }
}