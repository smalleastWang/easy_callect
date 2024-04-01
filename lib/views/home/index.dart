import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/enums/StorageKey.dart';
import 'package:easy_collect/utils/storage.dart';
import 'package:easy_collect/widgets/DropDownMenu/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('首页'),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: const DropDownMenu(),
      ),
    );
  }
}