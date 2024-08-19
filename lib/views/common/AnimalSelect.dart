import 'package:easy_collect/enums/index.dart';
import 'package:easy_collect/models/dropDownMenu/DropDownMenu.dart';
import 'package:easy_collect/utils/OverlayManager.dart';
import 'package:easy_collect/views/precisionBreeding/data.dart';
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

class AnimalSelectPage extends ConsumerStatefulWidget {
  const AnimalSelectPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AnimalSelectPageState();
}

class _AnimalSelectPageState extends ConsumerState<AnimalSelectPage> {
  final GlobalKey<ListWidgetState> listWidgetKey = GlobalKey<ListWidgetState>();
  List<Map<String, dynamic>> selectedItems = []; // 用于保存选中的牛只项

  @override
  void dispose() {
    overlayEntryAllRemove();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<EnclosureModel>> weightInfoTree = ref.watch(weightInfoTreeProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('选择牛只'),
         actions: [
          GestureDetector(
            onTap: () {
              // 处理确定按钮的点击事件，输出选中的项
              if (selectedItems.isNotEmpty) {
                // 执行保存逻辑，或将数据传递给上一个页面
                print('选中的牛只项: ${selectedItems.length}');
              }
              Navigator.of(context).pop(selectedItems);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: const Text(
                '确定',
                style: TextStyle(color: Color(0xFF297DFF), fontSize: 14),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFFF1F5F9),
        child: Column(
          children: [
            Expanded(
              child: weightInfoTree.when(
                data: (data) {
                  return ListWidget<AnimalPageFamily>(
                    key: listWidgetKey,
                    pasture: PastureModel(
                      field: 'orgId',
                      options: data,
                    ),
                    provider: animalPageProvider,
                    filterList: [
                      DropDownMenuModel(name: '牛耳标', layerLink: LayerLink(), fieldName: 'no', widget: WidgetType.input),
                      DropDownMenuModel(name: '授权状态', list:  enumsStrValToOptions(AuthStatusEnum.values, true, false), layerLink: LayerLink(), fieldName: 'pastureAuth'),
                      DropDownMenuModel(name: '抵押状态', list:  enumsStrValToOptions(MortgageStatusEnum.values, true, false), layerLink: LayerLink(), fieldName: 'mortgage'),
                    ],
                    builder: (rowData) {
                      return AnimalItem(
                        rowData: rowData,
                        listWidgetKey: listWidgetKey,
                        isSelected: selectedItems.contains(rowData), // 检查当前项是否被选中
                        onSelect: _handleItemSelected, // 处理选中事件
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('加载数据时出错: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleItemSelected(Map<String, dynamic> rowData, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedItems.add(rowData);
      } else {
        selectedItems.remove(rowData);
      }
    });
  }
}

class AnimalItem extends StatelessWidget {
  final Map<String, dynamic> rowData;
  final GlobalKey<ListWidgetState> listWidgetKey;
  final bool isSelected; // 是否选中
  final Function(Map<String, dynamic>, bool) onSelect; // 选中事件回调

  const AnimalItem({
    super.key, 
    required this.rowData, 
    required this.listWidgetKey, 
    required this.isSelected, 
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    StateStatus stateStatus = getStateStatusFromValue(rowData["state"] ?? '');
    AuthStatus pastureAuthStatus = getAuthStatusFromValue(rowData["pastureAuth"] ?? '');
    String mortgageStatus = (rowData["mortgage"] ?? '0') == '0' ? '未抵押' : '已抵押';

    return InkWell(
      onTap: () {
        onSelect(rowData, !isSelected); // 切换选中状态
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildStatusContainer(stateStatus.description, stateStatus == StateStatus.available),
                const SizedBox(width: 10),
                Text(
                  rowData["no"] ?? '未知',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Checkbox(
                  value: isSelected, // 根据当前状态确定是否选中
                  onChanged: (value) {
                    onSelect(rowData, value ?? false);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow('牧场', rowData["orgName"]),
            _buildInfoRow('圈舍', rowData["buildName"]),
            _buildInfoRow('授权状态', pastureAuthStatus.description),
            _buildInfoRow('抵押状态', mortgageStatus),
            // const SizedBox(height: 12),
            // const Divider(height: 0.5, color: Color(0xFFE2E2E2)),
            // const SizedBox(height: 12),
            // Text('注册时间: ${rowData["createTime"] ?? '未知'}',
            //     style: const TextStyle(color: Color(0xFF999999))),
          ],
        ),
      ),
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