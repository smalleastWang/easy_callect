import 'dart:async';
import 'package:easy_collect/api/email.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_collect/widgets/List/index.dart';

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
                  return EmailItem(rowData: rowData);
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

  const EmailItem({super.key, required this.rowData});

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
        Text('更新时间: ${rowData["updateTime"]}',
            style: const TextStyle(color: Color(0xFF999999))),
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
          padding: EdgeInsets.only(right: 20),
          child: Text(
            '邮箱',
            style: TextStyle(color: Color(0xFF666666)),
          ),
        ),
        Expanded(
          child: Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: emailList.map((email) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF5D8FFD),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  email,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
