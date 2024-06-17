import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_collect/api/combo.dart';
import 'package:easy_collect/widgets/List/index.dart';

class ComboListPage extends ConsumerStatefulWidget {
  const ComboListPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ComboListPageState createState() => _ComboListPageState();
}

class _ComboListPageState extends ConsumerState<ComboListPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('套餐'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListWidget<ComboPageFamily>(
        provider: comboPageProvider,
        builder: (comboData) {
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: const Icon(Icons.folder, color: Colors.orange),
            title: Text(comboData['costName']),
            subtitle: Text('创建时间 ${comboData['createTime'] ?? '未知'}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // 处理点击事件
            },
          );
        },
      ),
    );
  }
}
