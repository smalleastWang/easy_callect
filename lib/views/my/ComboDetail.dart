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

  const ComboDetailPage({super.key, required this.state});

  @override
  State<ComboDetailPage> createState() => _ComboDetailState();
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
        flexibleSpace:
            Container(decoration: BoxDecoration(gradient: _appBarGradient)),
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
          'assets/images/combo_header.png',
          const LinearGradient(
            colors: [Color(0xFFEABB7E), Color(0xFFF9D9A7)],
          ),
          const Color(0xFFB67C1F),
          combo['costType'] ?? '-',
          combo['chargeType'] ?? '-',
          combo['canUseFunctions'] ?? [],
          combo['isEnable'] ?? '-',
          combo['extendDay'] ?? '-',
          combo['createTime'] ?? '-'),
    );
  }

  Widget _buildPackagePage(
    String costName,
    String comboType,
    String imagePath,
    Gradient backgroundColor,
    Color textColor,
    String costType,
    String chargeType,
    List<dynamic> canUseFunctions,
    String isEnabled,
    String extendDay,
    String createTime,
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
                offset:
                    const Offset(0, -20), // Move the container up by 20 pixels
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
                            padding:
                                const EdgeInsets.fromLTRB(16.0, 50, 16.0, 0),
                            child: Column(
                              children: [
                                PackageDetails(
                                  backgroundColor: textColor,
                                  costName: costName,
                                  comboType: comboType,
                                  chargeType: chargeType,
                                  costType: costType,
                                  canUseFunctions: canUseFunctions,
                                  extendDay: extendDay,
                                  isEnabled: isEnabled,
                                  createTime: createTime,
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
                  costName: costName,
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
  final String costName;
  final String comboType;
  final String imagePath;
  final Color textColor;
  final Color backgroundColor;

  const PackageHeader({
    super.key,
    required this.costName,
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
                  costName,
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
  final String costName;
  final String comboType;
  final String chargeType;
  final String costType;
  final List<dynamic> canUseFunctions;
  final String extendDay;
  final String isEnabled;
  final String createTime;

  const PackageDetails({
    super.key,
    required this.backgroundColor,
    required this.costName,
    required this.comboType,
    required this.chargeType,
    required this.costType,
    required this.canUseFunctions,
    required this.extendDay,
    required this.isEnabled,
    required this.createTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0), // Add border radius
        boxShadow: const [
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
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            child: Row(
              children: [
                Container(
                  // Container for the vertical line
                  height: 18,
                  width: 6.0,
                  color: backgroundColor,
                  margin: const EdgeInsets.only(right: 8.0),
                ),
                const Text(
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
                // PackageDetailRow(label: '套餐名称', value: costName),
                // PackageDetailRow(label: '套餐类型', value: comboType),
                // PackageDetailRow(label: '收费类型', value: chargeType),
                // PackageDetailRow(label: '授权方式', value: costType),
                // const SizedBox(height: 8.0),
                // const Divider(
                //   height: 0.5,
                //   color: Color(0xFFE9E8E8),
                // ),
                // const SizedBox(height: 8.0),
                const Text(
                  '可使用功能',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: canUseFunctions
                      .map((function) => Chip(
                            label: Text(
                              function["name"],
                              style: const TextStyle(color: Color(0xFF666666)),
                            ),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                color: Color(0xFFA2ABBE), // 边框颜色
                                width: 0.5, // 边框宽度
                              ),
                              borderRadius:
                                  BorderRadius.circular(3.0), // 圆角半径，可以根据需要调整
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 16.0),
                const Divider(
                  height: 0.5,
                  color: Color(0xFFE9E8E8),
                ),
                const SizedBox(height: 8.0),
                // PackageDetailRow(label: '延期天数', value: extendDay),
                PackageDetailRow(label: '创建时间', value: createTime),
              ],
            ),
          ),
          const SizedBox(height: 16.0), // Bottom padding
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
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 20.0), // 添加20px的间距
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16.0,
                color: Color(0xFF666666),
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
