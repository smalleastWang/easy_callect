import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:easy_collect/models/combo/Combo.dart';
import 'package:easy_collect/api/combo.dart';

class PackageScreenPage extends StatefulWidget {
  const PackageScreenPage({super.key});

  @override
  State<PackageScreenPage> createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreenPage> {
  final PageController _pageController = PageController();
  late Future<List<Combo>> futureComboList;
  Gradient _appBarGradient = const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF5082F6), Color(0xFF84B0FE)], // 渐变色开始和结束颜色
  );

  @override
  void initState() {
    super.initState();
    futureComboList = comboList(); // 调用 comboList 函数获取数据
  }

  void _onPageChanged(int index) {
    switch (index) {
      case 0:
        _appBarGradient = const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF5082F6), Color(0xFF84B0FE)],
        );
        break;
      case 1:
        _appBarGradient = const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFEABB7E), Color(0xFFF9D9A7)],
        );
        break;
      case 2:
        _appBarGradient = const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFF2554C), Color(0xFFFFA496)],
        );
        break;
      case 3:
        _appBarGradient = const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF8093CA), Color(0xFFB2BFE1)],
        );
        break;
      default:
        break;
    }
    setState(() {
      _appBarGradient = _appBarGradient;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace:
            Container(decoration: BoxDecoration(gradient: _appBarGradient)),
        title: const Text('套餐'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<List<Combo>>(
        future: futureComboList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('没有套餐'));
          } else {
            final comboList = snapshot.data!;
            return Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  physics: const BouncingScrollPhysics(),
                  itemCount: comboList.length,
                  itemBuilder: (context, index) {
                    final combo = comboList[index];
                    return _buildPackagePage(
                      combo.costName,
                      '10.0元', // 替换为实际折扣价格字段
                      'assets/images/套餐-基础套餐.png', // 替换为实际图像路径字段
                      _appBarGradient,
                      const Color(0xFF34466F), // 替换为实际颜色字段
                      '10.0元', // 替换为实际套餐牛只/次数字段
                      '3.0元', // 替换为实际单价字段
                      '15.4元', // 替换为实际套餐总费用字段
                      '按功能收费', // 替换为实际套餐类型字段
                      '永久授权', // 替换为实际授权方式字段
                      '按年', // 替换为实际收费类型字段
                      '启用', // 替换为实际是否启用字段
                      '365天', // 替换为实际启用天数字段
                    );
                  },
                ),
                Positioned(
                  bottom: 16.0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: comboList.length,
                      effect: const WormEffect(), // Customize the effect
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildPackagePage(
    String title,
    String discountedPrice,
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
                  discountedPrice: discountedPrice,
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
  final String discountedPrice;
  final String imagePath;
  final Color textColor;
  final Color backgroundColor;

  const PackageHeader({
    super.key,
    required this.title,
    required this.discountedPrice,
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
        offset: const Offset(0, -110),
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
                  '折后价：$discountedPrice',
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
    super.key,
    required this.backgroundColor,
    required this.cattleCount,
    required this.unitPrice,
    required this.totalCost,
    required this.packageType,
    required this.authorizationType,
    required this.billingType,
    required this.isEnabled,
    required this.enabledDays,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    // Container for the vertical line
                    height: 18,
                    width: 6.0,
                    color: backgroundColor, // Choose the color you want for the line
                    margin: const EdgeInsets.only(
                        right: 8.0), // Add margin to separate the line from text
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
              const SizedBox(height: 8.0),
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
          SizedBox(
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
          SizedBox(
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
