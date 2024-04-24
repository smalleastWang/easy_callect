
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/widgets/cell/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InsurancePage extends StatelessWidget {
  const InsurancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(RouteEnum.insurance.title),
      ),
      body: Column(
        children: [
          CellWidget(title: '验标注册', onTap: () => context.go(RouteEnum.standardVerification.fullpath!)),
          CellWidget(title: '勘查对比', onTap: () async {
            final result = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NewPage(),
              ),
            );

            // 如果新页面返回了一个值，你可以在这里获取到
            if (result != null) {
              // 处理返回值
              print('New page returned: $result');
            }
          }),
          const CellWidget(title: '生成订单'),
          const CellWidget(title: '订单查询'),
          const CellWidget(title: '计数盘点')
        ],
      ),
    );
  }
}


class NewPage extends StatelessWidget {
  // 新页面的构建方法
  @override
  Widget build(BuildContext context) {
    // 当你想要返回一个值时，可以使用Navigator.pop
    // 例如，返回一个字符串
    Navigator.pop(context, 'Hello from new page');
    return Container();
  }
}