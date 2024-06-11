import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PackageScreenPage extends StatefulWidget {
  const PackageScreenPage({super.key});

  @override
  _PackageScreenState createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreenPage> {
  final PageController _pageController = PageController();
  Gradient _appBarGradient = const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF5082F6), Color(0xFF84B0FE)], // 渐变色开始和结束颜色
  );

  void _onPageChanged(int index) {
    print(index);
    switch (index) {
      case 0:
        _appBarGradient = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF5082F6), Color(0xFF84B0FE)],
        );
        break;
      case 1:
        _appBarGradient = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFEABB7E), Color(0xFFF9D9A7)],
        );
        break;
      case 2:
        _appBarGradient = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFF2554C), Color(0xFFFFA496)],
        );
        break;
      case 3:
        _appBarGradient = LinearGradient(
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
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            physics: const BouncingScrollPhysics(),
            children: [
              _buildPackagePage(
                '基础套餐',
                '8.0元',
                'assets/images/套餐-基础套餐.png',
                _appBarGradient,
                const Color(0xFF34466F),
                '10.0元',
                '3.0元',
                '15.4元',
                '按功能收费',
                '永久授权',
                '按年',
                '启用',
                '365天',
              ),
              _buildPackagePage(
                '安享套餐',
                '10.0元',
                'assets/images/套餐-安享套餐.png',
                _appBarGradient,
                const Color(0xFFB67C1F),
                '10.0元',
                '5.0元',
                '20.5元',
                '按功能收费',
                '永久授权',
                '按年',
                '启用',
                '365天',
              ),
              _buildPackagePage(
                '计数盘点套餐',
                '10.0元',
                'assets/images/套餐-计数盘点套餐.png',
                _appBarGradient,
                const Color(0xFFF45C53),
                '10.0元',
                '5.0元',
                '20.5元',
                '按功能收费',
                '永久授权',
                '按年',
                '启用',
                '365天',
              ),
              _buildPackagePage(
                '赠送套餐',
                '10.0元',
                'assets/images/套餐-赠送套餐.png',
                _appBarGradient,
                const Color(0xFF34466F),
                '10.0元',
                '5.0元',
                '20.5元',
                '按功能收费',
                '永久授权',
                '按年',
                '启用',
                '365天',
              ),
            ],
          ),
          Positioned(
            bottom: 16.0,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: 4,
                effect: const WormEffect(), // Customize the effect
              ),
            ),
          ),
        ],
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
          decoration: BoxDecoration(gradient: _appBarGradient),
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

  const PackageDetails({super.key, 
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
      child: Container(
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
                      color:
                          backgroundColor, // Choose the color you want for the line
                      margin: const EdgeInsets.only(
                          right:
                              8.0), // Add margin to separate the line from text
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
      ),
    );
  }
}

class PackageDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const PackageDetailRow({super.key, required this.label, required this.value});

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
