import 'package:easy_collect/api/performanceDetail.dart';
import 'package:easy_collect/widgets/List/ListCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_collect/widgets/List/index.dart';
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
  final GlobalKey<ListWidgetState> _listWidgetKey = GlobalKey<ListWidgetState>();
  DateTime _startDate = DateTime(DateTime.now().year, DateTime.now().month - 1, DateTime.now().day);
  DateTime _endDate = DateTime.now();
  final TextEditingController _dateRangeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateRangeController.text = '${DateFormat('yyyy-MM-dd').format(_startDate)} - ${DateFormat('yyyy-MM-dd').format(_endDate)}';
  }

  String _getTitle() {
    switch (widget.dataType) {
      case '0':
        return '身长';
      case '2':
        return '身高';
      case '4':
        return '肩宽';
      case '5':
        return '十字部高';
      case '6':
        return '体斜长';
      case '7':
        return '胸围';
      case '8':
        return '腹围';
      case '9':
        return '管围';
      default:
        return '体征详情';
    }
  }

  void _refreshData() {
    _listWidgetKey.currentState!.getList(_createRequestParams());
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
        title: Text(_getTitle()),
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
                    labelText: '选择测定日期',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: const BorderSide(color: Color(0xFFF5F7F9)), // 设置默认边框颜色
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: const BorderSide(color: Color(0xFFF5F7F9)), // 设置未聚焦时的边框颜色
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      borderSide: const BorderSide(color: Color(0xFF5D8FFD)), // 设置聚焦时的边框颜色
                    ),
                    suffixIcon: const Icon(Icons.date_range_outlined, color: Color(0xFF5D8FFD)),
                    fillColor: const Color(0xFFF1F5F9), // 设置背景色为白色
                    filled: true, // 启用填充颜色
                  ),
                  style: const TextStyle(color: Color(0xFF999999)), // 设置输入文本颜色
                  readOnly: true,
                  onTap: () => _selectDateRange(context),
                ),
              ),
            ),
            Expanded(
              child: ListWidget<PerformanceDetailPageFamily>(
                key: _listWidgetKey,
                params: _createRequestParams(),
                provider: performanceDetailPageProvider,
                builder: (rowData) {
                  return PerformanceDetailItem(rowData: rowData);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PerformanceDetailItem extends StatelessWidget {
  final Map<String, dynamic> rowData;

  const PerformanceDetailItem({super.key, required this.rowData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListCardCell(label: '牛耳标号', value: rowData['animalNo'], marginTop: 0),
        ListCardCell(label: '唯一识别码', value: rowData['algorithmCode']),
        ListCardCell(label: '测定值', value: rowData['dataValue']),
        ListCardCellTime(label: '采集时间', value: rowData['date']),
      ],
    );
  }
}