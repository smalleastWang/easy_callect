import 'package:easy_collect/models/bill/Bill.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BillDetailPage extends StatefulWidget {
  final GoRouterState state;
  const BillDetailPage({super.key, required this.state});

  @override
  State<BillDetailPage> createState() => _BillDetailPageState();
}

class _BillDetailPageState extends State<BillDetailPage> {
  late GoRouterState state;
  Bill? bill;

  @override
  void initState() {
    super.initState();
    state = widget.state;
    bill = state.extra as Bill?;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // 设置页面背景色
      appBar: AppBar(
        backgroundColor: const Color(0xFF5082F6),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          '账单详情',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: [
                Container(
                  color: const Color(0xFF5082F6), // 设置背景色
                  height: 100,
                  width: double.infinity,
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(12, 20, 12, 0),
                    child: Image.asset(
                      'assets/images/bill_header.png', 
                      fit: BoxFit.cover,
                    ),
                  )
                ),
                Positioned(
                  top: 60.0,
                  left: 32.0,
                  right: 32.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '账单生成时间：${bill?.createTime ?? '未知'}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF999999),
                        ),
                      ),
                      SizedBox(height: 12.0), // Add space between the texts
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '实付：',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                          ),
                          SizedBox(width: 4), // 添加一个小的间距
                          Text(
                            bill?.totalPrice ?? '0.00',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                color: Colors.white,
                child: Container(
                  padding: EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 128.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      buildDetailRow('续费状态', _getChargeStateText(bill?.chargeState), isLink: true),
                      buildDivider(),
                      buildDetailRow('套餐名称', bill?.costName ?? '未知'),
                      buildDivider(),
                      buildDetailRow('授权方式', _getAuthorizationType(bill?.costType)),
                      buildDivider(),
                      buildDetailRow('购买数量', bill?.purchaseNum ?? '未知'),
                      buildDivider(),
                      buildDetailRow('剩余数量', bill?.relayNum ?? '未知'),
                      buildDivider(),
                      buildDetailRow('审批通过时间', bill?.approveTime ?? '未知'),
                      buildDivider(),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Center(
                child: Image.asset(
                  'assets/images/bill_footer.png', // Replace with your image path
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getAuthorizationType(String? costType) {
    switch (costType) {
      case '0':
        return '临时授权';
      case '1':
        return '永久授权';
      case '2':
        return '其他';
      default:
        return '未知';
    }
  }

  String _getComboType(String? comboType) {
    switch (comboType) {
      case '0':
        return '按功能收费';
      case '1':
        return '按设备收费';
      default:
        return '未知';
    }
  }

  String _buildSubtitle(Bill bill) {
    if (bill.createTime != null) {
      DateTime dateTime = DateTime.parse(bill.createTime!);
      String formattedDate =
          '${dateTime.year}-${dateTime.month}-${dateTime.day}';
      return formattedDate;
    }
    return '未知';
  }

  String _getChargeStateText(String? chargeState) {
    switch (chargeState) {
      case '0':
        return '已发布';
      case '1':
        return '已缴费待审批';
      case '2':
        return '财务审批通过';
      case '3':
        return '审批通过';
      case '4':
        return '审批打回';
      default:
        return '未知';
    }
  }

  Widget buildDetailRow(String title, String value, {bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontSize: 16, color: const Color(0xFF666666)),
          ),
          if (isLink)
            GestureDetector(
              onTap: () {},
              child: Text(
                value,
                style: TextStyle(fontSize: 16, color: const Color(0xFF5082F6)),
              ),
            )
          else
            Text(
              value,
              style: TextStyle(fontSize: 16, color: const Color(0xFF444444)),
            ),
        ],
      ),
    );
  }

  Widget buildDivider() {
    return Container(
      height: 0.5,
      color: const Color(0xFFE9E8E8),
      margin: EdgeInsets.symmetric(vertical: 4.0),
    );
  }
}
