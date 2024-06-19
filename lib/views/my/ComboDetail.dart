import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum ComboType { functionality, device }

extension ComboTypeExtension on ComboType {
  String get description {
    switch (this) {
      case ComboType.functionality:
        return '按功能收费';
      case ComboType.device:
        return '按设备收费';
      default:
        return '未知';
    }
  }

  static ComboType fromString(String value) {
    switch (value) {
      case '0':
        return ComboType.functionality;
      case '1':
        return ComboType.device;
      default:
        return ComboType.functionality; // Default value
    }
  }
}

class ComboDetailPage extends StatefulWidget {
  final GoRouterState state;

  const ComboDetailPage({Key? key, required this.state}) : super(key: key);

  @override
  _ComboDetailState createState() => _ComboDetailState();
}

class _ComboDetailState extends State<ComboDetailPage> {
  late GoRouterState state;
  final Gradient _appBarGradient = const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFEABB7E), Color(0xFFF9D9A7)], // 渐变色开始和结束颜色
  );

  @override
  void initState() {
    super.initState();
    state = widget.state;
  }

  @override
  Widget build(BuildContext context) {
    // 从路由状态中获取传递的数据
    final Map<String, dynamic>? combo = state.extra as Map<String, dynamic>?;

    if (combo == null) {
      // Handle the case where combo is null
      return Scaffold(
        appBar: AppBar(
          flexibleSpace:
              Container(decoration: BoxDecoration(gradient: _appBarGradient)),
          title: const Text('套餐详情'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: const Center(
          child: Text('套餐数据为空'),
        ),
      );
    }

    final comboType = ComboTypeExtension.fromString(combo['comboType'] ?? '0');

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(decoration: BoxDecoration(gradient: _appBarGradient)),
        title: Text(combo['costName']),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _buildPackagePage(
          combo['costName'],
          comboType.description,
          'assets/images/套餐-安享套餐.png',
          const LinearGradient(
            colors: [Color(0xFFEABB7E), Color(0xFFF9D9A7)],
          ),
          const Color(0xFFB67C1F), // 替换为实际颜色字段
          combo['giveMaxTimes'] ?? '未知',
          '3.0元', // 替换为实际单价字段
          '15.4元', // 替换为实际套餐总费用字段
          combo['comboType'] ?? '未知',
          combo['costType'] ?? '未知',
          combo['chargeType'] ?? '未知',
          combo['isEnable'] ?? '未知',
          combo['extendDay'] ?? '未知',
        ),
    );
  }

  Widget _buildPackagePage(
    String title,
    String comboType,
    String imagePath,
    Gradient backgroundColor,
    Color textColor,
    String cattleCount,
    String unitPrice,
    String totalCost,
    String packageType,
    String authorizationType,
    String billingType,
    String isEnabled,
    String enabledDays,
  ) {
    return Column(
      children: [
        Container(
          height: 120.0, // Adjust height for the top section background
          decoration: BoxDecoration(gradient: backgroundColor),
        ),
        Expanded(
          child: Stack(
            children: [
              Transform.translate(
                offset: const Offset(0, -20), // Move the container up by 20 pixels
                child: ClipRRect(
                  child: Container(
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(16.0, 50, 16.0, 0),
                            child: Column(
                              children: [
                                PackageDetails(
                                  backgroundColor: textColor,
                                  cattleCount: cattleCount,
                                  unitPrice: unitPrice,
                                  totalCost: totalCost,
                                  packageType: packageType,
                                  authorizationType: authorizationType,
                                  billingType: billingType,
                                  isEnabled: isEnabled,
                                  enabledDays: enabledDays,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: PackageHeader(
                  title: title,
                  comboType: comboType,
                  imagePath: imagePath,
                  textColor: textColor,
                  backgroundColor: textColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PackageHeader extends StatelessWidget {
  final String title;
  final String comboType;
  final String imagePath;
  final Color textColor;
  final Color backgroundColor;

  const PackageHeader({
    super.key,
    required this.title,
    required this.comboType,
    required this.imagePath,
    required this.textColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
      child: Transform.translate(
        offset: const Offset(0, -100),
        child: Container(
          width: double.infinity,
          height: 115.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  '套餐类型：$comboType',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PackageDetails extends StatelessWidget {
  final Color backgroundColor;
  final String cattleCount;
  final String unitPrice;
  final String totalCost;
  final String packageType;
  final String authorizationType;
  final String billingType;
  final String isEnabled;
  final String enabledDays;

  const PackageDetails({
    Key? key,
    required this.backgroundColor,
    required this.cattleCount,
    required this.unitPrice,
    required this.totalCost,
    required this.packageType,
    required this.authorizationType,
    required this.billingType,
    required this.isEnabled,
    required this.enabledDays,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0), // Add border radius
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            child: Row(
              children: [
                Container(
                  // Container for the vertical line
                  height: 18,
                  width: 6.0,
                  color: backgroundColor,
                  margin: const EdgeInsets.only(right: 8.0),
                ),
                Text(
                  '套餐权益',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 0.5,
            color: Color(0xFFE9E8E8),
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PackageDetailRow(label: '套餐牛只/次数', value: cattleCount),
                PackageDetailRow(label: '单价', value: unitPrice),
                PackageDetailRow(label: '套餐总费用', value: totalCost),
                PackageDetailRow(label: '套餐类型', value: packageType),
                PackageDetailRow(label: '授权方式', value: authorizationType),
                PackageDetailRow(label: '收费类型', value: billingType),
                PackageDetailRow(label: '是否启用', value: isEnabled),
                PackageDetailRow(label: '启用天数', value: enabledDays),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PackageDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const PackageDetailRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Container(
            width: 180.0, // 设置宽度
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold, // Left column in bold
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 100.0, // 设置宽度
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
