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
          return Container(
            color: const Color(0xFFF1F5F9),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      _buildHeader(data),
                      const SizedBox(height: 12),
                      _buildInfoRows(data),
                      const SizedBox(height: 12),
                      const Divider(height: 0.5, color: Color(0xFFE2E2E2)),
                      const SizedBox(height: 12),
                      Text('合同生效日期: ${data["effectiveTime"]}', style: const TextStyle(color: Color(0xFF999999))),
                      Text('合同期满日期: ${data["expiryTime"]}', style: const TextStyle(color: Color(0xFF999999))),
                      Text('创建时间: ${data["createTime"]}', style: const TextStyle(color: Color(0xFF999999))),
                    ],
                  ),
                ),
              ],
            ),
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
            data["policyContent"],
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          data["policyNo"],
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildInfoRows(Map<String, dynamic> data) {
    return Column(
      children: [
        _buildTwoColumns('保险费', data["premium"].toString(), '联系人', data["person"]),
        const SizedBox(height: 12),
        _buildTwoColumns('联系电话', data["phone"], '农户（机构）名称', data["farmerName"]),
        const SizedBox(height: 12),
        _buildTwoColumns('身份证号码', data["idCardNumber"], '畜龄', data["animalAge"]),
        const SizedBox(height: 12),
        _buildTwoColumns('农户地址', data["farmerAdress"], '毛色', data["coatColor"]),
        const SizedBox(height: 12),
        _buildTwoColumns('畜别', data["animalType"], '养殖地点', data["breedingBase"]),
        const SizedBox(height: 12),
        _buildTwoColumns('品种', data["animalVariety"], '银行账号', data["bankAccount"]),
        const SizedBox(height: 12),
        _buildTwoColumns('账户名称', data["accountName"], '健康状况', data["isHealthy"]),
        const SizedBox(height: 12),
        _buildTwoColumns('是否有检验', data["isQuarantine"], '银行名称', data["bankName"]),
        const SizedBox(height: 12),
        _buildTwoColumns('开户行省', data["bankProvince"], '开户行市', data["bankCity"]),
        const SizedBox(height: 12),
        _buildTwoColumns('备注', data["remarks"], '', ''),
      ],
    );
  }

  Widget _buildTwoColumns(String label1, dynamic value1, String label2, dynamic value2) {
    return Row(
      children: [
        Expanded(child: _buildInfoRow(label1, value1)),
        Expanded(child: _buildInfoRow(label2, value2)),
      ],
    );
  }

  Widget _buildInfoRow(String label, dynamic value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(color: Color(0xFF3B81F2)),
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