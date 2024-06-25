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
  void _navigateTo(String path) {
    context.push(path);
  }

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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.white, // Ensure AlertDialog background is white
          contentPadding: const EdgeInsets.all(0),
          content: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ), // Ensure container background is white with rounded corners
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
                      Text('确认退出当前用户？', textAlign: TextAlign.left, style: TextStyle(fontSize: 16, color: Colors.black)),
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
                        onPressed: () {
                          Navigator.pop(context);
                          _logoutAndNavigateToLogin();
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
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: screenHeight - 90,
          ),
          decoration: const BoxDecoration(
            color: Color(0xffF1F5F9),
          ),
          child: Column(
            children: [
              const Image(
                image: AssetImage("assets/images/logo02.png"),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Transform.translate(
                  offset: const Offset(0.0, -20.0),
                  child: Column(
                    children: [
                      CellWidget(
                        assetIcon: "assets/icon/my/shop.png",
                        title: '套餐展示',
                        onTap: () => _navigateTo(RouteEnum.comboList.path),
                      ),
                      CellWidget(
                        assetIcon: "assets/icon/my/shopping_bag.png",
                        title: '我的账单',
                        onTap: () => _navigateTo(RouteEnum.billList.path),
                      ),
                      CellWidget(
                        assetIcon: "assets/icon/my/feed.png",
                        title: '基本信息',
                        onTap: () => _navigateTo(RouteEnum.userInfo.path),
                      ),
                      CellWidget(
                        assetIcon: "assets/icon/my/download.png",
                        title: '资料下载',
                        onTap: () => _navigateTo(RouteEnum.downLoad.path),
                      ),
                      const CellWidget(
                        assetIcon: "assets/icon/my/help.png",
                        title: '帮助手册',
                      ),
                      const CellWidget(
                        assetIcon: "assets/icon/my/call.png",
                        title: '联系我们',
                      ),
                      CellWidget(
                        assetIcon: "assets/icon/my/logout.png",
                        title: '退出登录',
                        onTap: _showLogoutConfirmationDialog,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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
              image: AssetImage("assets/images/logo02.png"),
            ),
          ),
          Text(version),
        ],
      ),
    );
  }
}
