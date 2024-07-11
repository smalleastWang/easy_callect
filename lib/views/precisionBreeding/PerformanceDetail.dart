import 'package:easy_collect/api/performanceDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:easy_collect/models/performance/PerformanceDetail.dart';
import 'package:intl/intl.dart';

class PerformanceDetailPage extends ConsumerStatefulWidget {
  final String algorithmCode;
  final String dataType;

  const PerformanceDetailPage({
    super.key,
    required this.algorithmCode,
    required this.dataType,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PerformanceDetailPageState();
}

class _PerformanceDetailPageState extends ConsumerState<PerformanceDetailPage> {
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _startDate = DateTime(today.year, today.month - 1, today.day);
    _endDate = today;
    _refreshData();
  }

  void _refreshData() {
    ref.refresh(performanceDetailPageProvider(_createRequestParams()));
  }

  Map<String, dynamic> _createRequestParams() {
    return {
      'algorithmCode': widget.algorithmCode,
      'dataType': widget.dataType,
      'startDate': DateFormat('yyyy-MM-dd').format(_startDate),
      'endDate': DateFormat('yyyy-MM-dd').format(_endDate),
    };
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && (picked.start != _startDate || picked.end != _endDate)) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _refreshData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<PerformanceDetail>> performanceDetails = ref.watch(
      performanceDetailPageProvider(_createRequestParams()) as ProviderListenable<AsyncValue<List<PerformanceDetail>>>
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('体征详情'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selectDateRange(context),
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFFF1F5F9),
        child: Column(
          children: [
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '选择的日期范围: ${DateFormat('yyyy-MM-dd').format(_startDate)} - ${DateFormat('yyyy-MM-dd').format(_endDate)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: performanceDetails.when(
                data: (data) {
                  return ListWidget<PerformanceDetailPageFamily>(
                    provider: performanceDetailPageProvider,
                    builder: (rowData) {
                      return PerformanceDetailItem(rowData: rowData);
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

class PerformanceDetailItem extends StatelessWidget {
  final rowData;

  const PerformanceDetailItem({super.key, required this.rowData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Spacer(),
            Text(
              rowData.animalNo ?? '未知',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 12),
        _buildInfoRow('唯一识别码', rowData.algorithmCode),
        _buildInfoRow('测定值', rowData.dataValue),
        _buildInfoRow('采集时间', rowData.date),
        const SizedBox(height: 12),
        const Divider(height: 0.5, color: Color(0xFFE2E2E2)),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        '$label: ${value ?? '未知'}',
        style: const TextStyle(color: Color(0xFF666666)),
      ),
    );
  }
}