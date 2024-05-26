import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_collect/enums/Route.dart';

class ModuleWidget extends StatelessWidget {
  const ModuleWidget({super.key});

  Widget buildModule(String title, List<Widget> buttons, {bool showDivider = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: buttons,
        ),
        if (showDivider)
          const Divider(
            height: 20,
            thickness: 0.5, // 更细的分割线
            color: Color(0xFFE5E5E5), // 指定颜色
          ),
      ],
    );
  }

  Widget buildButton(String label, IconData icon, Color color, {Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('功能模块'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              buildModule('智慧保险', [
                buildButton('验标注册', Icons.assignment_ind, Colors.blue, onTap: () => context.push(RouteEnum.standardVerification.fullpath)),
                buildButton('查勘对比', Icons.search, Colors.blue, onTap: () => context.push(RouteEnum.surveyCompared.fullpath)),
                buildButton('生成订单', Icons.note_add, Colors.blue, onTap: () => context.push(RouteEnum.orderList.fullpath)),
                buildButton('订单查询', Icons.receipt, Colors.blue, onTap: () => context.push(RouteEnum.orderList.fullpath)),
                buildButton('计数盘点', Icons.format_list_numbered, Colors.blue, onTap: () => context.push(RouteEnum.countRegister.fullpath)),
                buildButton('投保人管理', Icons.security, Colors.blue, onTap: () => context.push(RouteEnum.insurance.fullpath)),
              ]),
              buildModule('养殖金融', [
                buildButton('牛只注册', Icons.assignment, Colors.orange, onTap: () => context.push(RouteEnum.cattleRegiter.fullpath)),
                buildButton('计数盘点', Icons.format_list_numbered, Colors.orange, onTap: () => context.push(RouteEnum.financeCount.fullpath)),
                buildButton('牛只识别', Icons.qr_code, Colors.orange, onTap: () => context.push(RouteEnum.cattleDiscern.fullpath)),
                buildButton('实时视频', Icons.videocam, Colors.orange, onTap: () => context.push(RouteEnum.financeVideo.fullpath)),
              ]),
              buildModule('精准养殖', [
                buildButton('智能盘点', Icons.inventory, Colors.green, onTap: () => context.push(RouteEnum.inventory.fullpath)),
                buildButton('性能测定', Icons.show_chart, Colors.green, onTap: () => context.push(RouteEnum.performance.fullpath)),
                buildButton('智能估重', Icons.monitor_weight, Colors.green, onTap: () => context.push(RouteEnum.weight.fullpath)),
                buildButton('行为分析', Icons.analytics, Colors.green, onTap: () => context.push(RouteEnum.behavior.fullpath)),
                buildButton('健康状态', Icons.health_and_safety, Colors.green, onTap: () => context.push(RouteEnum.health.fullpath)),
                buildButton('实时定位', Icons.location_on, Colors.green, onTap: () => context.push(RouteEnum.position.fullpath)),
                buildButton('智能安防', Icons.security, Colors.green, onTap: () => context.push(RouteEnum.security.fullpath)),
                buildButton('在位识别', Icons.check_circle, Colors.green, onTap: () => context.push(RouteEnum.milksidentify.fullpath)),
              ]),
              buildModule('行业监管', [
                buildButton('养殖规模', Icons.business, Colors.red, onTap: () => context.push(RouteEnum.breedingScale.fullpath)),
                buildButton('抵押信息', Icons.info, Colors.red, onTap: () => context.push(RouteEnum.mortgageInfo.fullpath)),
                buildButton('投保信息', Icons.verified_user, Colors.red, onTap: () => context.push(RouteEnum.insureInfo.fullpath)),
                buildButton('健康检测', Icons.local_hospital, Colors.red, onTap: () => context.push(RouteEnum.healthCheck.fullpath)),
              ]),
              buildModule('管理设置', [
                buildButton('圈舍信息', Icons.home, Colors.blueAccent, onTap: () => context.push(RouteEnum.pen.fullpath)),
                buildButton('牛只信息', Icons.info_outline, Colors.blueAccent, onTap: () => context.push(RouteEnum.userInfo.fullpath)),
                buildButton('AI盒子管理', Icons.computer, Colors.blueAccent, onTap: () => context.push(RouteEnum.inventory.fullpath)),
                buildButton('摄像头管理', Icons.videocam, Colors.blueAccent, onTap: () => context.push(RouteEnum.surveyCompared.fullpath)),
                buildButton('套餐管理', Icons.manage_accounts, Colors.blueAccent, onTap: () => context.push(RouteEnum.downLoad.fullpath)),
                buildButton('账单管理', Icons.receipt_long, Colors.blueAccent, onTap: () => context.push(RouteEnum.orderList.fullpath)),
                buildButton('续费表管理', Icons.table_chart, Colors.blueAccent, onTap: () => context.push(RouteEnum.orderList.fullpath)),
                buildButton('邮箱设置', Icons.email, Colors.blueAccent, onTap: () => context.push(RouteEnum.userInfo.fullpath)),
              ], showDivider: false),
            ],
          ),
        ),
      ),
    );
  }
}
