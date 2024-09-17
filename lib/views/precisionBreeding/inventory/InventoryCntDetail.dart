import 'package:easy_collect/api/inventory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_collect/widgets/List/index.dart';

class InventoryCntDetailPage extends ConsumerStatefulWidget {
  final String buildingId;
  final String taskId;
  const InventoryCntDetailPage({super.key, required this.buildingId, required this.taskId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InventoryCntDetailPageState();
}

class _InventoryCntDetailPageState extends ConsumerState<InventoryCntDetailPage> {
  final GlobalKey<ListWidgetState> listWidgetKey = GlobalKey<ListWidgetState>();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusSearchInputNode = FocusNode();
  AsyncValue<List<dynamic>> dataList = const AsyncValue.loading();

  Map<String, dynamic> _createRequestParams() {
    return {
      "easyCvrId": _searchController.text,
      "current": 1,
      "buildingId": widget.buildingId,
      "taskId": widget.taskId,
    };
  }

  void _onSearch() {
    _fetchList();
  }

  void _fetchList() {
    final provider = inventoryCntDetailProvider(_createRequestParams());
    ref.read(provider.future).then((data) {
      if (mounted) {
        setState(() {
          dataList = AsyncValue.data(data);
        });
      }
    }).catchError((error) {
      print('Error fetching data list: $error');
    });
  }


  @override
  void initState() {
    super.initState();
     _fetchList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('计数盘点明细'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          _focusSearchInputNode.unfocus();
        },
        child: Container(
          color: const Color(0xFFF1F5F9),
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
                  child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return TextField(
                        controller: _searchController,
                        focusNode: _focusSearchInputNode,
                        decoration: InputDecoration(
                          hintText: '请输入设备编号',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: const Color(0xFFF5F7F9),
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_searchController.text.isNotEmpty)
                                IconButton(
                                  icon: const Icon(Icons.clear, color: Color(0xFF666666), size: 24.0),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {}); // Update the state to refresh the suffixIcon
                                    _onSearch();
                                  },
                                ),
                              TextButton(
                                onPressed: () => _onSearch(),
                                style: TextButton.styleFrom(
                                  backgroundColor: const Color(0xFF5D8FFD),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                  minimumSize: const Size(50.0, 40.0),
                                ),
                                child: const Text(
                                  '搜索',
                                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onChanged: (_) {
                          setState(() {}); // Update the state to refresh the suffixIcon
                        },
                        onSubmitted: (_) => _onSearch(),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: dataList.when(
                 data: (data) => data.isNotEmpty 
                    ? _buildDataList(context, data) 
                    : _buildNoDataWidget(),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('Error: $error')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildDataList(BuildContext context, List<dynamic> dataList) {
  return ListView.builder(
    itemCount: dataList.length,
    itemBuilder: (context, index) {
      final rowData = dataList[index];
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
            child: InventoryCntDetailItem(
              rowData: rowData,
            ),
          ),
        ],
      );
    },
  );
}

class InventoryCntDetailItem extends StatelessWidget {
  final Map<String, dynamic> rowData;

  const InventoryCntDetailItem({
    super.key,
    required this.rowData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white, // 背景颜色白色
        borderRadius: BorderRadius.circular(6.0), // 圆角 6px
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('序号', rowData["id"] ?? '-'),
           const SizedBox(height: 12),
          _buildInfoRow('设备编号', rowData["easyCvrId"] ?? '-'),
           const SizedBox(height: 12),
          _buildInfoRow('盘点数量', rowData["currentNum"] ?? '-'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, dynamic? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Row(
        children: [
          Text(
            '$label     ',
            style: const TextStyle(color: Color(0xFF666666)),
          ),
          Expanded(
            child: Text(
              value == null || value.toString().isEmpty ? '未知' : value.toString(),
              style: const TextStyle(color: Color(0xFF666666)),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildNoDataWidget() {
  return Container(
    color: Colors.white,
    width: double.infinity,
    height: double.infinity,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty.png',
            fit: BoxFit.contain,
            width: double.infinity,
            height: 200,
          ),
          Transform.translate(
            offset: const Offset(0, -40),
            child: const Text(
              '没有查询到数据',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF666666),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}