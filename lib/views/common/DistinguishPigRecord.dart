import 'package:easy_collect/widgets/List/ListCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:easy_collect/api/distinguishRecord.dart';
import 'package:easy_collect/widgets/List/index.dart';

class DistinguishPigRecordPage extends ConsumerStatefulWidget {
  const DistinguishPigRecordPage({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DistinguishPigRecordPageState();
}

class _DistinguishPigRecordPageState extends ConsumerState<DistinguishPigRecordPage> {
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
        title: const Text('猪识别记录'),
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
              child: ListWidget<DistinguishPigRecordPageFamily>(
                key: _listWidgetKey,
                params: _createRequestParams(),
                provider: distinguishPigRecordPageProvider,
                builder: (rowData) {
                  return DistinguishPigRecordItem(rowData: rowData);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DistinguishPigRecordItem extends StatelessWidget {
  final Map<String, dynamic> rowData;

  const DistinguishPigRecordItem({super.key, required this.rowData});

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
        ListCardCell(
          label: '牧场名称',
          value: rowData['orgName'],
        ),
        ListCardCell(
          label: '操作人',
          value: rowData['userName'],
        ),
        ListCardCell(
          label: '唯一识别码',
          value: rowData['algorithmCode'],
        ),
         ListCardCellTime(
          label: '识别时间',
          value: rowData["createTime"],
        ),
      ],
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