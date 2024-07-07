import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/api/precisionBreeding.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:easy_collect/api/animal.dart';

enum StateStatus {
  available,
  disabled,
  duplicate,
  lost,
  registering,
  sold,
  deceased,
  preRegistered,
  mergedPreRegistered,
}

extension StateStatusExtension on StateStatus {
  String get description {
    switch (this) {
      case StateStatus.available:
        return '可用';
      case StateStatus.disabled:
        return '禁用';
      case StateStatus.duplicate:
        return '手机端与摄像头重复';
      case StateStatus.lost:
        return '盘点牛只丢失';
      case StateStatus.registering:
        return '手机端注册中';
      case StateStatus.sold:
        return '出栏';
      case StateStatus.deceased:
        return '死亡';
      case StateStatus.preRegistered:
        return '预注册';
      case StateStatus.mergedPreRegistered:
        return '预注册已合并';
      default:
        return '未知';
    }
  }
}

StateStatus getStateStatusFromValue(String value) {
  switch (value) {
    case '0':
      return StateStatus.available;
    case '1':
      return StateStatus.disabled;
    case '2':
      return StateStatus.duplicate;
    case '3':
      return StateStatus.lost;
    case '4':
      return StateStatus.registering;
    case '5':
      return StateStatus.sold;
    case '6':
      return StateStatus.deceased;
    case '7':
      return StateStatus.preRegistered;
    case '8':
      return StateStatus.mergedPreRegistered;
    default:
      return StateStatus.disabled;
  }
}

enum AuthStatus {
  unauthorized,
  authorized,
  expired,
  revoked,
}

extension AuthStatusExtension on AuthStatus {
  String get description {
    switch (this) {
      case AuthStatus.unauthorized:
        return '未授权';
      case AuthStatus.authorized:
        return '已授权';
      case AuthStatus.expired:
        return '过期';
      case AuthStatus.revoked:
        return '取消授权';
      default:
        return '未知';
    }
  }
}

AuthStatus getAuthStatusFromValue(String value) {
  switch (value) {
    case '0':
      return AuthStatus.unauthorized;
    case '1':
      return AuthStatus.authorized;
    case '2':
      return AuthStatus.expired;
    case '3':
      return AuthStatus.revoked;
    default:
      return AuthStatus.unauthorized;
  }
}

class AnimalPage extends ConsumerStatefulWidget {
  const AnimalPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AnimalPageState();
}

class _AnimalPageState extends ConsumerState<AnimalPage> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<EnclosureModel>> weightInfoTree = ref.watch(weightInfoTreeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('牛只信息'),
      ),
      body: Container(
        color: const Color(0xFFF1F5F9),
        child: Column(
          children: [
            const SizedBox(height: 6),
            Expanded(
              child: weightInfoTree.when(
                data: (data) {
                  return ListWidget<AnimalPageFamily>(
                    pasture: PastureModel(
                      field: 'orgId',
                      options: data,
                    ),
                    provider: animalPageProvider,
                    builder: (rowData) {
                      return AnimalItem(rowData: rowData);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => _buildErrorWidget(err),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text('加载数据时出错: $error',
              style: const TextStyle(color: Color(0xFF666666), fontSize: 16)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                ref.refresh(weightInfoTreeProvider);
              });
            },
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }
}

class AnimalItem extends StatelessWidget {
  final Map<String, dynamic> rowData;

  const AnimalItem({super.key, required this.rowData});

  @override
  Widget build(BuildContext context) {
    StateStatus stateStatus = getStateStatusFromValue(rowData["state"]);
    AuthStatus pastureAuthStatus = getAuthStatusFromValue(rowData["pastureAuth"]);
    AuthStatus bankAuthStatus = getAuthStatusFromValue(rowData["bankAuth"]);
    String mortgageStatus = rowData["mortgage"] == '0' ? '未抵押' : '已抵押';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildStatusContainer(stateStatus.description, stateStatus == StateStatus.available),
            const SizedBox(width: 10),
            Text(
              rowData["no"],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 12),
        _buildInfoRow('牧场', rowData["orgName"]),
        _buildInfoRow('圈舍', rowData["buildName"]),
        _buildInfoRow('授权状态', pastureAuthStatus.description),
        // _buildInfoRow('金融机构授权状态', bankAuthStatus.description),
        _buildInfoRow('抵押状态', mortgageStatus),
        // _buildInfoRow('种类', rowData["type"]),
        // _buildInfoRow('繁殖状态', rowData["breed"]),
        const SizedBox(height: 12),
        const Divider(height: 0.5, color: Color(0xFFE2E2E2)),
        const SizedBox(height: 12),
        Text('注册时间: ${rowData["createTime"]}',
            style: const TextStyle(color: Color(0xFF999999))),
      ],
    );
  }

  Widget _buildStatusContainer(String status, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF5D8FFD) : const Color(0xFFCCCCCC),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        status,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        '$label     ${value == null || value.isEmpty ? '未知' : value}',
        style: const TextStyle(color: Color(0xFF666666)),
      ),
    );
  }
}