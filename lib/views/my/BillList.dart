import 'package:easy_collect/models/bill/Bill.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_collect/api/bill.dart'; // 假设这里提供了获取账单数据的API
import 'package:easy_collect/widgets/List/index.dart';
import 'package:easy_collect/enums/Route.dart';

class BillListPage extends StatefulWidget {
  const BillListPage({Key? key}) : super(key: key);

  @override
  State<BillListPage> createState() => _BillListPageState();
}

class _BillListPageState extends State<BillListPage> {
  void _navigateToDetail(Bill bill) {
    // context.push(RouteEnum.billDetail.path, extra: bill);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的账单'),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: const Color(0xFFF1F5F9),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: ListWidget<BillPageFamily>(
          provider: billPageProvider, // 确保这个provider提供了Bill数据
          builder: (billData) {
            final bill = Bill.fromJson(billData);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: Container(
                  color: Colors.white,
                  child: BillCard(bill: bill),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class BillCard extends StatelessWidget {
  final Bill bill;

  const BillCard({required this.bill});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF5D8FFD),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _getChargeStateText(bill.chargeState),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  bill.costName ?? '图像盘点名称',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text('授权方式：${_getAuthorizationType(bill.costType)}'),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('套餐类型：${_getComboType(bill.comboType)}'),
                  Text(
                    '￥${bill.totalPrice ?? '0.00'}',
                    style: const TextStyle(
                      color: Color(0xFFFE6B01),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(
                height: 0.5,
                color: Color(0xFFE2E2E2),
              ),
              const SizedBox(height: 12), // 调整行间距为8px
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('账单生成时间：${_buildSubtitle(bill)}'),
                  // TextButton(
                  //   onPressed: () {
                  //     _navigateToDetail(bill);
                  //   },
                  //   child: const Text('查看凭证'),
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    child: GestureDetector(
                      onTap: () => _navigateToDetail(bill),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        // decoration: BoxDecoration(
                        //   borderRadius: BorderRadius.circular(20),
                        //   color: const Color(0xFF297DFF),
                        // ),
                        child: const Text(
                          '查看凭证',
                          style:
                              TextStyle(color: Color(0xFF297DFF), fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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

  void _navigateToDetail(Bill bill) {
    // 导航到详情页
    // context.push(RouteEnum.billDetail.path, extra: bill); // 需要 GoRouter 支持
  }
}
