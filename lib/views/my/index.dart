import 'package:easy_collect/widgets/cell/index.dart';
import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('用户中心'),
      ),
      body: const Column(
        children: [
          _MyHeaderWidget(version: 'sss'),
          CellWidget(icon: Icons.shop, title: '套餐展示'),
          CellWidget(icon: Icons.shopping_bag, title: '已经订购套餐'),
          CellWidget(icon: Icons.feed, title: '基本信息'),
          CellWidget(icon: Icons.download, title: '资料下载'),
          CellWidget(icon: Icons.help, title: '帮助手册'),
          CellWidget(icon: Icons.call, title: '联系我们'),
          CellWidget(icon: Icons.logout, title: '退出登录'),
        ],
      ),
    );
  }
}


class _MyHeaderWidget extends StatelessWidget {
  final String version;
  const _MyHeaderWidget({required this.version});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 28, bottom: 10),
            child: Image(
              width: 100,
              image: AssetImage("assets/images/logo01.png"),
            ),
          ),
          Text(version),
        ],
      ),
    );
  }
}
