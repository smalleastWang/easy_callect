import 'package:easy_collect/views/home/module.dart';
import 'package:easy_collect/views/message/index.dart';
import 'package:easy_collect/views/my/index.dart';
import 'package:easy_collect/utils/icons.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final int? currentIndex;
  const HomePage({super.key, this.currentIndex});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  void initState() {
    super.initState();
    if (widget.currentIndex != null) {
      _currentIndex = widget.currentIndex!;
    }
  }

  int _currentIndex = 1;
  final List<Widget> _widgetList = [
    const MessageWidget(),
    const ModuleWidget(),
    const MyWidget(),
  ];

  List<BottomNavigationBarItem> _bottomBars() {
    return [
      const BottomNavigationBarItem(
        label: '消息通知',
        icon: Icon(MyIcons.message),
        activeIcon: Icon(MyIcons.messageActive),
      ),
      const BottomNavigationBarItem(
        label: '功能模块',
        icon: Icon(MyIcons.module),
        activeIcon: Icon(MyIcons.moduleActive)
      ),
      const BottomNavigationBarItem(
        label: '用户中心',
        icon: Icon(MyIcons.person),
        activeIcon: Icon(MyIcons.personActive)
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetList[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: _bottomBars(),
        currentIndex: _currentIndex,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
      )
    );
  }
}