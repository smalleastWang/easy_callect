import 'dart:async';
import 'package:easy_collect/api/email.dart';
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/widgets/Button/PrimaryActionButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:go_router/go_router.dart';

class EmailPage extends ConsumerStatefulWidget {
  const EmailPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EmailPageState();
}

class _EmailPageState extends ConsumerState<EmailPage> {
  final GlobalKey<ListWidgetState> listWidgetKey = GlobalKey<ListWidgetState>();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  Map<String, dynamic> _createRequestParams() {
    return {
      'searchKey': _searchController.text,
    };
  }

  void _navigateTo(String path, [Map<String, dynamic>? rowData]) async {
    bool? result = await context.push(path, extra: rowData);
    // 如果返回结果为true，则刷新列表
    if (result == true) {
      listWidgetKey.currentState?.refreshWithPreviousParams();
    }
  }

  void _editEmail([Map<String, dynamic>? rowData]) {
    _navigateTo(RouteEnum.editEmail.path, rowData);
  }

  Future<void> deleteEmail(String id) async {
    try {
      List<Map<String, String?>> ids = [];
      ids.add({'id': id});
      await delEmail(ids); // 调用删除 API
      // 显示删除成功的提示
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('删除成功')),
      );
      // 等待1秒再刷新列表
      await Future.delayed(const Duration(seconds: 1));
      listWidgetKey.currentState?.refreshWithPreviousParams();
    } catch (e) {
      // 处理删除失败的情况
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('删除失败: $e')),
      );
    }
  }

  void _onSearch() {
    if (listWidgetKey.currentState != null) {
      listWidgetKey.currentState!.getList(_createRequestParams());
    }
  }

  void _onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _onSearch();
    });
  }

  void _showDeleteConfirmationDialog(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(0),
          content: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 42),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('提示', textAlign: TextAlign.left, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                      SizedBox(height: 20),
                      Text('确认删除该邮箱？', textAlign: TextAlign.left, style: TextStyle(fontSize: 16, color: Colors.black)),
                    ],
                  ),
                ),
                const Divider(height: 0.5, color: Color(0xFFE9E8E8)),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Color(0xFFE9E8E8), width: 0.5),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                          child: const Text('取消', style: TextStyle(color: Color(0xFF666666))),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await deleteEmail(id);
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        child: const Text('确定', style: TextStyle(color: Colors.blue)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onTextChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('邮箱管理'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _editEmail,
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFFFFFFFF),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: '请输入牧场',
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
                      fillColor: const Color(0xFFF5F7F9),
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.red, size: 24.0),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {}); // Update the state to refresh the suffixIcon
                                _onSearch();
                              },
                            )
                          : null,
                    ),
                    onChanged: (_) {
                      setState(() {}); // Update the state to refresh the suffixIcon
                    },
                    onSubmitted: (_) => _onSearch(),
                  );
                },
              ),
            ),
            Expanded(
              child: ListWidget<EmailPageFamily>(
                key: listWidgetKey,
                provider: emailPageProvider,
                builder: (rowData) {
                  return EmailItem(
                    rowData: rowData,
                    deleteEmailCallback: (String id) => _showDeleteConfirmationDialog(id),
                    editEmail: _editEmail
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmailItem extends StatelessWidget {
  final Map<String, dynamic> rowData;
  final Function(String) deleteEmailCallback;
  final Function(Map<String, dynamic>) editEmail;

  const EmailItem({
    super.key,
    required this.rowData,
    required this.deleteEmailCallback,
    required this.editEmail
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('牧场', rowData["orgName"]),
        _buildInfoRow('姓名', rowData["name"]),
        _buildEmails(rowData["emails"]),
        const SizedBox(height: 12),
        const Divider(height: 0.5, color: Color(0xFFE2E2E2)),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            PrimaryActionButton(
              text: '修改',
              onPressed: () => editEmail(rowData),
            ),
            const SizedBox(width: 10),
            OutlineActionButton(
              text: '删除',
              onPressed: () => deleteEmailCallback(rowData['id']),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(
            '$label     ',
            style: const TextStyle(color: Color(0xFF666666)),
          ),
          Expanded(
            child: Text(
              value == null || value.isEmpty ? '未知' : value,
              style: const TextStyle(color: Color(0xFF666666)),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmails(String? emails) {
    if (emails == null || emails.isEmpty) {
      return _buildInfoRow('邮箱', '未知');
    }

    List<String> emailList = emails.split('、');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: Text('邮箱     ', style: TextStyle(color: Color(0xFF666666))),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: emailList.map((email) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  email,
                  style: const TextStyle(color: Color(0xFF666666)),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}