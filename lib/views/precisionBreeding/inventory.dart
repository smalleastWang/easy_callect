import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/widgets/cell/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(RouteEnum.inventory.title),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '识别盘点'),
            Tab(text: '计数盘点'),
            Tab(text: '图像盘点'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Center(child: Text('识别盘点')),
          Center(child: Text('计数盘点')),
          Center(child: Text('图像盘点')),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
