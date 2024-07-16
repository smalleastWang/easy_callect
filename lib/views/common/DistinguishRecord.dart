import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:easy_collect/api/distinguishRecord.dart';
import 'package:easy_collect/widgets/List/index.dart';

class DistinguishRecordPage extends ConsumerStatefulWidget {
  const DistinguishRecordPage({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DistinguishRecordPageState();
}

class _DistinguishRecordPageState extends ConsumerState<DistinguishRecordPage> {
  final GlobalKey<ListWidgetState> _listWidgetKey = GlobalKey<ListWidgetState>();
  DateTime _startDate = DateTime(DateTime.now().year, DateTime.now().month - 1, DateTime.now().day);
  DateTime _endDate = DateTime.now();
  final TextEditingController _dateRangeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateRangeController.text = '${DateFormat('yyyy-MM-dd').format(_startDate)} - ${DateFormat('yyyy-MM-dd').format(_endDate)}';
  }

  void _refreshData() {
    _listWidgetKey.currentState!.getList(_createRequestParams());
  }

  Map<String, dynamic> _createRequestParams() {
    return {
      'startDate': DateFormat('yyyy-MM-dd').format(_startDate),
      'endDate': DateFormat('yyyy-MM-dd').format(_endDate),
    };
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && (picked.start != _startDate || picked.end != _endDate)) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        _dateRangeController.text = '${DateFormat('yyyy-MM-dd').format(_startDate)} - ${DateFormat('yyyy-MM-dd').format(_endDate)}';
      });
      _refreshData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('牛识别记录'),
      ),
      body: Container(
        color: const Color(0xFFF1F5F9),
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _dateRangeController,
                  decoration: InputDecoration(
                    labelText: '选择识别日期',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: const BorderSide(color: Color(0xFFF5F7F9)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: const BorderSide(color: Color(0xFFF5F7F9)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: const BorderSide(color: Color(0xFF5D8FFD)),
                    ),
                    suffixIcon: const Icon(Icons.date_range_outlined, color: Color(0xFF5D8FFD)),
                    fillColor: const Color(0xFFF1F5F9),
                    filled: true,
                  ),
                  style: const TextStyle(color: Color(0xFF999999)),
                  readOnly: true,
                  onTap: () => _selectDateRange(context),
                ),
              ),
            ),
            Expanded(
              child: ListWidget<DistinguishRecordPageFamily>(
                key: _listWidgetKey,
                params: _createRequestParams(),
                provider: distinguishRecordPageProvider,
                builder: (rowData) {
                  return DistinguishRecordItem(rowData: rowData);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DistinguishRecordItem extends StatelessWidget {
  final Map<String, dynamic> rowData;

  const DistinguishRecordItem({super.key, required this.rowData});

  @override
  Widget build(BuildContext context) {
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
                _getStateText(rowData['state']),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              rowData['no'] == null || rowData['no'].isEmpty ? '未上传耳标号' : rowData['no'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 12),
        _buildInfoRow('牧场名称', rowData['orgName']),
        _buildInfoRow('操作人', rowData['userName']),
        _buildInfoRow('唯一识别码', rowData['algorithmCode']),
        // _buildInfoRow('牛耳标', rowData['no']),
        // _buildInfoRow('识别时间', rowData['createTime']),
        // _buildInfoRow('识别状态', _getStateText(rowData['state'])),
        const Divider(height: 0.5, color: Color(0xFFE2E2E2)),
        const SizedBox(height: 12),
        Text('识别时间: ${rowData["createTime"]}',
            style: const TextStyle(color: Color(0xFF999999))),
      ],
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        '$label     ${value ?? '未知'}',
        style: const TextStyle(color: Color(0xFF666666)),
      ),
    );
  }

  String _getStateText(String? state) {
    switch (state) {
      case '0':
        return '识别成功';
      case '1':
        return '识别失败';
      default:
        return '未知状态';
    }
  }
}