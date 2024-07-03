import 'package:flutter/material.dart';
import 'package:easy_collect/api/combo.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_collect/enums/Route.dart';

class ComboListPage extends StatefulWidget {
  const ComboListPage({super.key});

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
      body: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Container(
            color: Colors.white,
            child: ListWidget<ComboPageFamily>(
              provider: comboPageProvider,
              builder: (comboData) {
                return Column(
                  children: [
                    Container(
                      color: const Color.fromRGBO(255, 255, 255, 1),
                      child: ListTile(
                        leading: Image.asset(
                          'assets/icon/my/combo.png',
                          width: 24, // 设置图片宽度
                          height: 26, // 设置图片高度
                        ),
                        title: Text(comboData['costName']),
                        subtitle: Text('创建时间 ${comboData['createTime'] ?? '未知'}'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          _navigateToDetail(comboData);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
    );
  }
}