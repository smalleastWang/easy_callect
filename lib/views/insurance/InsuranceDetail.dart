import 'package:easy_collect/widgets/List/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_collect/api/insurance.dart';

class InsuranceDetailPage extends ConsumerStatefulWidget {
  final String id;

  const InsuranceDetailPage({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InsuranceDetailPageState();
}

class _InsuranceDetailPageState extends ConsumerState<InsuranceDetailPage> {
  final GlobalKey<ListWidgetState> _listWidgetKey = GlobalKey<ListWidgetState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }

  void _refreshData() {
    if (_listWidgetKey.currentState != null) {
      try {
        _listWidgetKey.currentState!.getList(_createRequestParams());
      } catch (e) {
        // Handle exception if necessary
        print('Error refreshing data: $e');
      }
    }
  }

  Map<String, dynamic> _createRequestParams() {
    return {
      'policyId': widget.id,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('保险详情'),
        backgroundColor: Colors.white,
      ),
      body: ListWidget<InsuranceDetailFamily>(
        key: _listWidgetKey,
        params: _createRequestParams(),
        provider: insuranceDetailProvider,
        builder: (data) {
          return Column(
              children: [
                _buildHeader(data),
                const SizedBox(height: 8),
                _buildInfoRows(data),
                const SizedBox(height: 8),
                const Divider(height: 0.5, color: Color(0xFFE2E2E2)),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.only(bottom: 2.0), // 设置底部间距
                    //   child: Align(
                    //     alignment: Alignment.centerLeft,
                    //     child: Text(
                    //       '合同生效日期: ${data["effectiveTime"] ?? '-'}',
                    //       style: const TextStyle(color: Color(0xFF999999)),
                    //     ),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(bottom: 2.0), // 设置底部间距
                    //   child: Align(
                    //     alignment: Alignment.centerLeft,
                    //     child: Text(
                    //       '合同期满日期: ${data["expiryTime"] ?? '-'}',
                    //       style: const TextStyle(color: Color(0xFF999999)),
                    //     ),
                    //   ),
                    // ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('创建时间： ${data["createTime"] ?? '-'}', style: const TextStyle(color: Color(0xFF999999))),
                    ),
                  ],
                )
              ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(Map<String, dynamic> data) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF5D8FFD),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            data["farmerName"] ?? '-',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          data["startNo"] ?? '-',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildInfoRows(Map<String, dynamic> data) {
    return Column(
      children: [
        _buildTwoColumns('唯一码', data["algorithmCode"], '性别', data["animalSex"] == 1 ? '公' : '母'),
        const SizedBox(height: 12),
        _buildTwoColumns('畜龄', data["animalAge"], '毛色', data["coatColor"]),
        const SizedBox(height: 12),
        _buildTwoColumns('身份证号码', data["idCardNumber"], '畜龄', data["animalAge"]),
        const SizedBox(height: 12),
        _buildTwoColumns('畜别', data["animalType"], '畜种', data["animalBreed"]),
        const SizedBox(height: 12),
        _buildTwoColumns('品种', data["animalVariety"], '健康状况', data["isHealthy"].toString() == "0" ? '是' : '否'),
        const SizedBox(height: 12),
        _buildTwoColumns('是否有检验', data["isQuarantine"].toString() == "0" ? '是' : '否', '承保数量', data["insuranceNum"]),
        const SizedBox(height: 12),
        _buildTwoColumns('单位保额', data["insuranceAmount"], '市场价格', data["marketValue"]),
        const SizedBox(height: 12),
        _buildTwoColumns('评定价格', data["evaluateValue"], null, null),
      ],
    );
  }

 Widget _buildTwoColumns(String label1, dynamic value1, String? label2, dynamic value2) {
  return Row(
    children: [
      Expanded(
        child: _buildInfoRow(label1, value1),
      ),
      if (label2 != null && value2 != null) // 仅在label2和value2不为null时显示第二列
        Expanded(
          child: _buildInfoRow(label2, value2),
        ),
    ],
  );
}

  Widget _buildInfoRow(String label, dynamic value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(color: Color(0xFF666666)),
          ),
          TextSpan(
            text: '${value ?? '未知'}',
            style: const TextStyle(color: Color(0xFF666666)),
          ),
        ],
      ),
    );
  }
}