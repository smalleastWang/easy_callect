import 'package:easy_collect/views/home/data.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ModuleWidget extends StatelessWidget {
  const ModuleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('功能模块'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView.separated(
          // shrinkWrap: true,
          itemCount:  moduleList.length,
          itemBuilder: (context, index) {
            final module = moduleList[index];
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    module.title ?? module.route?.title ?? '',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)
                  ),
                ),
                GridView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 25,
                    crossAxisCount: 4,
                    childAspectRatio: 1.0
                  ),
                  children: module.children.map((e) {
                    return InkWell(
                      onTap: () => context.push(e.route.fullpath),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Container(
                          //   padding: const EdgeInsets.all(8),
                          //   decoration: BoxDecoration(
                          //     color: module.bgColor.withOpacity(0.3),
                          //     borderRadius: BorderRadius.circular(4),
                          //   ),
                          //   child: Icon(e.icon, size: 18, color: module.bgColor),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8),
                          //   child: Image.asset(e.iconPath, width: 50),
                          // ),
                          Container(
                            width: 40,
                            height: 40,
                            child: Image.asset(e.iconPath, fit: BoxFit.contain),
                          ),
                          
                          const SizedBox(height: 10),
                          Text(e.title ?? e.route.title, style: const TextStyle(fontSize: 12))
                        ],
                      ),
                    );
                  }).toList()
                )
              ],
            ); 
          },
          separatorBuilder: (context, index) => const Divider(color: Color(0xFFE5E5E5), height: 30),
        ),
      ),
    );
  }
}