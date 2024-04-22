import 'package:easy_collect/enums/Route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ModuleListModel {
  RouteEnum route;
  Color? background;
  IconData icon;
  ModuleListModel({required this.route, this.background, required this.icon});
}

class ModuleWidget extends StatefulWidget {
  const ModuleWidget({super.key});

  @override
  State<ModuleWidget> createState() => _ModuleWidgetState();
}

class _ModuleWidgetState extends State<ModuleWidget> {
  final List<ModuleListModel> moduleList = [
    ModuleListModel(route: RouteEnum.insurance, icon: Icons.ac_unit),
    ModuleListModel(route: RouteEnum.finance, icon: Icons.beach_access),
    ModuleListModel(route: RouteEnum.precisionBreeding, icon: Icons.cake),
    ModuleListModel(route: RouteEnum.supervision, icon: Icons.free_breakfast),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('功能模块'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            crossAxisCount: 2,
            childAspectRatio: 1.0
          ),
          children: moduleList.map((e) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.deepPurple
              ),
              child: GestureDetector(
                behavior:  HitTestBehavior.opaque,
                onTap: () => context.push(e.route.path),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(e.icon, size: 36, color: Colors.white),
                    const SizedBox(height: 10),
                    Text(e.route.title, style: const TextStyle(fontSize: 18, color: Colors.white))],
                ),
              ),
            );
          }).toList()
        ),
      ),
    );
  }
}