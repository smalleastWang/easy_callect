import 'package:easy_collect/enums/route.dart';
import 'package:easy_collect/models/buildings/building.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/api/precisionBreeding.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:easy_collect/api/building.dart';
import 'package:go_router/go_router.dart';

class BuildingPage extends ConsumerStatefulWidget {
  const BuildingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BuildingPageState();
}

class _BuildingPageState extends ConsumerState<BuildingPage> {
  final GlobalKey<ListWidgetState> listWidgetKey = GlobalKey<ListWidgetState>();

  Future<void> _toggleEnable(Building params) async {
    await toggleEnableBuilding(params);
    listWidgetKey.currentState?.refreshWithPreviousParams();
  }

  void _navigateTo(String path) async {
    bool? result = await context.push(path);
    // 如果返回结果为true，则刷新列表
    if (result == true) {
      listWidgetKey.currentState?.refreshWithPreviousParams();
    }
  }

  void _addNewBuilding() {
    _navigateTo(RouteEnum.editBuilding.path);
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<EnclosureModel>> weightInfoTree = ref.watch(weightInfoTreeProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('圈舍信息'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addNewBuilding,
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
                  return ListWidget<BuildingPageFamily>(
                    key: listWidgetKey,
                    pasture: PastureModel(
                      field: 'orgId',
                      options: data,
                    ),
                    provider: buildingPageProvider,
                    builder: (rowData) {
                      return BuildingItem(
                        rowData: rowData,
                        onToggle: _toggleEnable,
                      );
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
  final Future<void> Function(Building) onToggle;

  const BuildingItem({super.key, required this.rowData, required this.onToggle});

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        '$label     ${value == null || value.isEmpty ? '未知' : value}',
        style: const TextStyle(color: Color(0xFF666666)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String onlineStatus = rowData["state"] == "0" ? "启用" : "禁用";
    bool isEnabled = rowData["state"] == "0";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              rowData["buildingName"],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              onlineStatus
            ),
            Switch(
              value: isEnabled,
              onChanged: (value) {
                Building building = Building.fromJson(rowData);
                building.state = value ? "0" : "1";
                onToggle(building);
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildInfoRow('牧场', rowData["orgName"]),
        _buildInfoRow('期初数量', rowData["maxNum"]),
        _buildInfoRow('当前牛数量', rowData["currentNum"]),
        _buildInfoRow('栋别', rowData["blockNum"]),
        _buildInfoRow('栏别', rowData["hurdleNum"]),
      ],
    );
  }
}