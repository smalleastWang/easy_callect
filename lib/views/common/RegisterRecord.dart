import 'package:easy_collect/enums/index.dart';
import 'package:easy_collect/models/dropDownMenu/DropDownMenu.dart';
import 'package:easy_collect/utils/OverlayManager.dart';
import 'package:easy_collect/views/precisionBreeding/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        title: const Text('牛注册记录'),
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
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
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
                                    borderRadius: BorderRadius.circular(12.0),
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
                child: ListWidget<RegisterRecordPageFamily>(
                  key: _listWidgetKey,
                  params: _createRequestParams(),
                  provider: registerRecordPageProvider,
                  filterList: [
                    DropDownMenuModel(name: '注册状态', list: enumsStrValToOptions(RegistStatusEnum.values, true, false), layerLink: LayerLink(), fieldName: 'state'),
                    DropDownMenuModel(name: '注册时间', layerLink: LayerLink(), fieldName: 'createTime', widget: WidgetType.datePicker),
                  ],
                  builder: (rowData) {
                    return RegisterRecordItem(rowData: rowData);
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