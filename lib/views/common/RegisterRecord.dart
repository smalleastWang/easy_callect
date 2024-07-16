import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:easy_collect/api/registerRecord.dart';
import 'package:easy_collect/widgets/List/index.dart';

class RegisterRecordPage extends ConsumerStatefulWidget {
  const RegisterRecordPage({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterRecordPageState();
}

class _RegisterRecordPageState extends ConsumerState<RegisterRecordPage> {
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
        title: const Text('牛注册记录'),
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
                    labelText: '选择注册日期',
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
              child: ListWidget<RegisterRecordPageFamily>(
                key: _listWidgetKey,
                params: _createRequestParams(),
                provider: registerRecordPageProvider,
                builder: (rowData) {
                  return RegisterRecordItem(rowData: rowData);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterRecordItem extends StatelessWidget {
  final Map<String, dynamic> rowData;

  const RegisterRecordItem({super.key, required this.rowData});

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
              rowData['no'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 12),
        _buildInfoRow('所属圈舍', rowData['buildingName']),
        _buildInfoRow('操作人', rowData['userName']),
        _buildInfoRow('数据来源', _getRegisterTypeText(rowData['registerType'])),
        _buildInfoRow('唯一码', rowData['algorithmCode']),
        // _buildInfoRow('牛耳标', rowData['no']),
        // _buildInfoRow('注册状态', _getStateText(rowData['state'])),
        const SizedBox(height: 12),
        const Divider(height: 0.5, color: Color(0xFFE2E2E2)),
        const SizedBox(height: 12),
        Text('注册时间: ${rowData["createTime"]}',
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
        return '注册成功';
      case '1':
        return '注册失败';
      case '2':
        return '待审核';
      default:
        return '未知状态';
    }
  }

  String _getRegisterTypeText(int? registerType) {
    switch (registerType) {
      case 0:
        return '摄像头端';
      case 1:
        return '手机端';
      case 2:
        return '其他';
      case 3:
        return '无人机';
      default:
        return '未知来源';
    }
  }
}