import 'package:easy_collect/views/home/data.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ModuleWidget extends StatelessWidget {
  const ModuleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('功能模块'),
      ),
      body: Container(
        color: const Color(0xffF1F5F9), // 设置页面背景色
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // 设置整个页面距离两边12px, 上下6px
        child: ListView.builder(
          itemCount: moduleList.length,
          itemBuilder: (context, index) {
            final module = moduleList[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (index != 0) const SizedBox(height: 6), // 大模块之间的间距为6px
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // 设置大模块背景色为白色
                    borderRadius: BorderRadius.circular(9), // 设置大模块圆角为9px
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12), // 设置大模块左右padding为10，上下padding为12
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          module.title ?? module.route?.title ?? '',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600), // 设置大模块标题字体大小为15px
                        ),
                      ),
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          crossAxisCount: 4,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: module.children.length,
                        itemBuilder: (context, childIndex) {
                          final e = module.children[childIndex];
                          return InkWell(
                            onTap: () => context.push(e.route.fullpath),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Transform.scale(
                                      scale: 1, // 缩放比例
                                      child: e.iconPath.endsWith('.svg')
                                          ? SvgPicture.asset(e.iconPath, fit: BoxFit.fill)
                                          : Image.asset(e.iconPath, fit: BoxFit.fill),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  e.title ?? e.route.title,
                                  style: const TextStyle(fontSize: 13, color: Color(0xFF444444)),
                                  softWrap: false, // 禁用自动换行
                                  maxLines: 1, // 限制为一行
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
