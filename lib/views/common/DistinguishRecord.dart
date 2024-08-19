import 'package:easy_collect/enums/index.dart';
import 'package:easy_collect/models/dropDownMenu/DropDownMenu.dart';
import 'package:easy_collect/utils/OverlayManager.dart';
import 'package:easy_collect/views/precisionBreeding/data.dart';
import 'package:easy_collect/widgets/List/ListCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusSearchInputNode = FocusNode();

  Map<String, dynamic> _createRequestParams() {
    return {
      'userName': _searchController.text,
    };
  }

  void _onSearch() {
    _focusSearchInputNode.unfocus();
    if (_listWidgetKey.currentState != null) {
      _listWidgetKey.currentState!.getList(_createRequestParams());
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    overlayEntryAllRemove();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('牛识别记录'),
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
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
                  child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return TextField(
                        controller: _searchController,
                        focusNode: _focusSearchInputNode,
                        decoration: InputDecoration(
                          hintText: '请输入操作人',
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
                child: ListWidget<DistinguishRecordPageFamily>(
                  key: _listWidgetKey,
                  params: _createRequestParams(),
                  provider: distinguishRecordPageProvider,
                  filterList: [
                    DropDownMenuModel(name: '识别状态', list: enumsStrValToOptions(DistinguishStatusEnum.values, true, false), layerLink: LayerLink(), fieldName: 'state', onTap: () => _focusSearchInputNode.unfocus()),
                    DropDownMenuModel(name: '识别时间', layerLink: LayerLink(), fieldName: 'createTime', widget: WidgetType.datePicker, onTap: () => _focusSearchInputNode.unfocus()),
                  ],
                  builder: (rowData) {
                    return DistinguishRecordItem(rowData: rowData);
                  },
                ),
              ),
            ],
          ),
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