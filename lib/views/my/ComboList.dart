import 'package:flutter/material.dart';
import 'package:easy_collect/api/combo.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_collect/enums/Route.dart';

class ComboListPage extends StatefulWidget {
  const ComboListPage({Key? key}) : super(key: key);

  @override
  State<ComboListPage> createState() => _ComboListPageState();
}

class _ComboListPageState extends State<ComboListPage> {
  void _navigateToDetail(combo) {
    context.push(RouteEnum.comboDetail.path, extra: combo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('套餐'),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: const Color(0xFFF1F5F9),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Container(
            color: Colors.white,
            child: ListWidget<ComboPageFamily>(
              provider: comboPageProvider,
              builder: (comboData) {
                return Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: const Icon(Icons.folder, color: Colors.orange),
                        title: Text(comboData['costName']),
                        subtitle: Text('创建时间 ${comboData['createTime'] ?? '未知'}'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          _navigateToDetail(comboData);
                        },
                      ),
                    ),
                    const Divider(
                      height: 0.5,
                      color: Color(0xFFE9E8E8),
                      indent: 12,
                      endIndent: 12,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}