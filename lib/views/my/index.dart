import 'package:easy_collect/widgets/cell/index.dart';
import 'package:flutter/material.dart';
import 'package:easy_collect/api/my.dart';
import 'package:easy_collect/enums/Route.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_collect/utils/storage.dart';
import 'package:easy_collect/enums/StorageKey.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  void _logoutAndNavigateToLogin() async {
    await MyApi.logoutApi(); // Call logout API
    await SharedPreferencesManager().remove(StorageKeyEnum.token.value);
    context.replace(RouteEnum.login.path);
  }
  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('提示'),
          content: const Text('确认退出当前用户？'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _logoutAndNavigateToLogin();
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('用户中心'),
      ),
      body: Column(
        children: [
          const _MyHeaderWidget(version: 'sss'),
          const CellWidget(icon: Icons.shop, title: '套餐展示'),
          const CellWidget(icon: Icons.shopping_bag, title: '已经订购套餐'),
          const CellWidget(icon: Icons.feed, title: '基本信息'),
          const CellWidget(icon: Icons.download, title: '资料下载'),
          const CellWidget(icon: Icons.help, title: '帮助手册'),
          const CellWidget(icon: Icons.call, title: '联系我们'),
          CellWidget(icon: Icons.logout, title: '退出登录', onTap: _showLogoutConfirmationDialog),
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
