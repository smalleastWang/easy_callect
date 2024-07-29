import 'package:easy_collect/views/message/New.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatefulWidget {
  const MessageWidget({super.key});

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> with SingleTickerProviderStateMixin {

  List tabs = ["最新公告", "系统信息"];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          controller: _tabController,
          tabs: tabs.map((e) => Tab(text: e)).toList()
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          NewMessageWidget(),
          Center(child: Text('系统消息')),
        ],
      ),
    );
  }
}