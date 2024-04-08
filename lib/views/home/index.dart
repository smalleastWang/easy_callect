import 'package:easy_collect/utils/init.dart';
import 'package:easy_collect/views/home/module.dart';
import 'package:easy_collect/views/message/index.dart';
import 'package:easy_collect/views/my/index.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _currentIndex = 1;
  final List<Widget> _widgetList = [
    const MessageWidget(),
    const ModuleWidget(),
    const MyWidget(),
    
  ];

  @override
  void initState() {
    App().appInit();
    super.initState();
  }

  List<BottomNavigationBarItem> _bottomBars() {
    return [
      const BottomNavigationBarItem(
        label: '消息通知',
        icon: Icon(Icons.chat),
      ),
      const BottomNavigationBarItem(
        label: '功能模块',
        icon: Icon(Icons.view_module),
      ),
      const BottomNavigationBarItem(
        label: '用户中心',
        icon: Icon(Icons.person),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: const DropDownMenu(),
      body: _widgetList[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomBars(),
        currentIndex: _currentIndex,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
      ),
    );
  }
}