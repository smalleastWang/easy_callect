import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/models/PageVo.dart';
import 'package:easy_collect/api/inventory.dart'; // Import the correct inventory.dart file
import 'package:easy_collect/models/Inventory/Image.dart';

class InventoryPage extends ConsumerStatefulWidget {
  const InventoryPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<ConsumerStatefulWidget> createState() => _InventoryPageState();
}

class _InventoryPageState extends ConsumerState<InventoryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _startTimeController = TextEditingController();
    _endTimeController = TextEditingController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(RouteEnum.inventory.title),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '图像盘点'),
            Tab(text: '识别盘点'),
            Tab(text: '计数盘点'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          // _buildImageInventoryPage(),
          Center(child: Text('图像盘点')),
          Center(child: Text('识别盘点')),
          Center(child: Text('计数盘点')),
        ],
      ),
    );
  }

  Widget _buildImageInventoryPage() {
    final AsyncValue<PageVoModel> imageInventoryAsyncValue = ref.watch(imageInventoryProvider({}));
    return Column(
      children: [
        TextField(
          controller: _startTimeController,
          decoration: const InputDecoration(labelText: '开始时间'),
        ),
        TextField(
          controller: _endTimeController,
          decoration: const InputDecoration(labelText: '结束时间'),
        ),
        ElevatedButton(
          onPressed: () => _fetchImageInventory(),
          child: const Text('搜索'),
        ),
        Expanded(
          child: imageInventoryAsyncValue.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
            data: (pageVoModel) {
              return ListView.builder(
                itemCount: pageVoModel.records.length,
                itemBuilder: (context, index) {
                  final ImageInventoryModel item = pageVoModel.records[index] as ImageInventoryModel;
                  return ListTile(
                    title: Text(item.name ?? ''),
                    subtitle: Text(item.createTime ?? ''),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _fetchImageInventory() async {
    final Map<String, dynamic> params = {
      'startTime': _startTimeController.text,
      'endTime': _endTimeController.text,
    };
    // ignore: unused_result
    ref.refresh(imageInventoryProvider(params));
  }
}