import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/api/precisionBreeding.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:easy_collect/api/email.dart';

class EmailPage extends ConsumerStatefulWidget {
  const EmailPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EmailPageState();
}

class _EmailPageState extends ConsumerState<EmailPage> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<EnclosureModel>> weightInfoTree = ref.watch(weightInfoTreeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('邮箱管理'),
      ),
      body: Container(
        color: const Color(0xFFF1F5F9),
        child: Column(
          children: [
            Expanded(
              child: weightInfoTree.when(
                data: (data) {
                  return ListWidget<EmailPageFamily>(
                    pasture: PastureModel(
                      field: 'orgId',
                      options: data,
                    ),
                    provider: emailPageProvider,
                    builder: (rowData) {
                      return EmailItem(rowData: rowData);
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