import 'package:easy_collect/api/inventory.dart';
import 'package:easy_collect/widgets/List/ListCard.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InventoryTotalAnimalPage extends ConsumerStatefulWidget {
  final String buildingId;
  final String inventoryId;
  const InventoryTotalAnimalPage({super.key, required this.buildingId, required this.inventoryId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InventoryTotalAnimalPageState();
}

class _InventoryTotalAnimalPageState extends ConsumerState<InventoryTotalAnimalPage> {
  final GlobalKey<ListWidgetState> listWidgetKey = GlobalKey<ListWidgetState>();

  Map<String, dynamic> _createRequestParams() {
    return {
      'buildingId': widget.buildingId,
      'id': widget.inventoryId,
    };
  }

  void _onSearch() {
    if (listWidgetKey.currentState != null) {
      listWidgetKey.currentState!.getList(_createRequestParams());
    }
  }

  @override
  void initState() {
    _onSearch();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('盘点总数明细'),
      ),
      body: Container(
        color: const Color(0xFFF1F5F9),
        child: Column(
          children: [
            Expanded(
              child: ListWidget<InventoryAnimalPageFamily>(
                provider: inventoryAnimalPageProvider,
                key: listWidgetKey,
                builder: (rowData) {
                  return InventoryAnimalPageItem(rowData: rowData);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InventoryAnimalPageItem extends StatelessWidget {
  final Map<String, dynamic> rowData;

  const InventoryAnimalPageItem({super.key, required this.rowData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListCardCell(
          label: '圈舍',
          value: rowData["buildingName"],
        ),
        ListCardCell(
          label: '唯一码',
          value: rowData["algorithmCode"],
        ),
        ListCardCell(
          label: '牛耳标',
          value: rowData["no"],
        ),
      ],
    );
  }
}