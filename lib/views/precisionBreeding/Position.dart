import 'package:easy_collect/api/precisionBreeding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:easy_collect/api/position.dart';
import 'package:easy_collect/enums/Route.dart';

class PositionPage extends ConsumerStatefulWidget {
  const PositionPage({super.key});

  @override
  _PositionPageState createState() => _PositionPageState();
}

class _PositionPageState extends ConsumerState<PositionPage> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<EnclosureModel>> weightInfoTree =
        ref.watch(weightInfoTreeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(RouteEnum.position.title),
      ),
      body: Container(
        color: const Color(0xFFF1F5F9),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            const SizedBox(height: 6),
            Expanded(
              child: weightInfoTree.when(
                data: (data) => buildListWidget(data),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('加载数据时出错: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListWidget(List<EnclosureModel> data) {
    return ListWidget<PositionPageFamily>(
      pasture: PastureModel(
        field: 'orgId',
        options: data,
      ),
      provider: positionPageProvider,
      builder: (positionData) {
        return PositionItem(rowData: positionData);
      },
    );
  }
}

class PositionItem extends StatelessWidget {
  final rowData;

  const PositionItem({super.key, required this.rowData});

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
            Text(
              '圈舍名称     ${rowData["buildingName"]}',
              style: const TextStyle(color: Color(0xFF666666)),
            ),
            const SizedBox(height: 12),
            Text(
              '牛耳标     ${rowData["animalNo"]}',
              style: const TextStyle(color: Color(0xFF666666)),
            ),
            // const SizedBox(height: 12),
            // Text(
            //   '唯一标识码: ${rowData["algorithmCode"]}',
            //   style: const TextStyle(color: Color(0xFF666666)),
            // ),
            const SizedBox(height: 12),
            const Divider(height: 0.5, color: Color(0xFFE2E2E2)),
            const SizedBox(height: 12),
            Text(
              '采集日期: ${rowData["inventoryDate"]}',
              style: const TextStyle(color: Color(0xFF999999)),
            ),
          ],
        ),
      ),
    );
  }
}