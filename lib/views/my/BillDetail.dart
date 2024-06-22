import 'package:flutter/material.dart';

class BillDetailPage extends StatefulWidget {
  const BillDetailPage({Key? key}) : super(key: key);

  @override
  State<BillDetailPage> createState() => _BillDetailPageState();
}

class _BillDetailPageState extends State<BillDetailPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
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
            Container(
              color: Colors.blue[300],
              height: 150,
              child: Center(
                child: Text(
                  '实付：0.00',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  buildDetailRow('账单生成时间', '2024-06-09 08:59:52'),
                  buildDetailRow('续费状态', '审批通过', isLink: true),
                  buildDetailRow('套餐名称', '图片计数盘点'),
                  buildDetailRow('授权方式', '永久授权'),
                  buildDetailRow('购买数量', '100'),
                  buildDetailRow('剩余数量', '90'),
                  buildDetailRow('审批通过时间', '2024-06-09 08:59:52'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDetailRow(String title, String value, {bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          if (isLink)
            GestureDetector(
              onTap: () {},
              child: Text(
                value,
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            )
          else
            Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
        ],
      ),
    );
  }
}