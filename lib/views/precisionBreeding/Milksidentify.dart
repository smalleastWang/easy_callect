import 'package:easy_collect/api/precisionBreeding.dart';
import 'package:easy_collect/models/dropDownMenu/DropDownMenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:easy_collect/api/milksidentify.dart';

class MilksidentifyPage extends ConsumerStatefulWidget {
  const MilksidentifyPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MilksidentifyPageState();
}

class _MilksidentifyPageState extends ConsumerState<MilksidentifyPage> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<EnclosureModel>> weightInfoTree =
        ref.watch(weightInfoTreeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('在位识别'),
      ),
      body: Container(
        color: const Color(0xFFF1F5F9),
        // padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            Expanded(
              child: weightInfoTree.when(
                data: (data) => buildListWidget(data),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('加载数据时出错: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListWidget(List<EnclosureModel> data) {
    return ListWidget<MilksidentifyPageFamily>(
      pasture: PastureModel(
        field: 'orgId',
        options: data,
      ),
      provider: milksidentifyPageProvider,
      filterList: [
        DropDownMenuModel(name: '牛耳标', layerLink: LayerLink(), fieldName: 'no', widget: WidgetType.input),
        DropDownMenuModel(name: '奶位号', layerLink: LayerLink(), fieldName: 'milkPos', widget: WidgetType.input),
        DropDownMenuModel(name: '预警日期', layerLink: LayerLink(), fieldName: 'startDate,endDate', widget: WidgetType.dateRangePicker),
      ],
      builder: (milksidentifyData) {
        return MilksidentifyItem(rowData: milksidentifyData);
      },
    );
  }
}

class MilksidentifyItem extends StatelessWidget {
  final Map<String, dynamic> rowData;

  const MilksidentifyItem({super.key, required this.rowData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '挤奶位编号     ${rowData["milkPos"]}',
          style: const TextStyle(color: Color(0xFF666666))
        ),
        // const SizedBox(height: 12),
        // Text(
        //   '牧场     ${rowData["orgName"]}',
        //   style: const TextStyle(color: Color(0xFF666666)),
        // ),
        const SizedBox(height: 12),
        Text(
          '耳标号      ${rowData["no"]}',
          style: const TextStyle(color: Color(0xFF666666)),
        ),
        const SizedBox(height: 12),
        Text('轮次     ${rowData["wave"] == null || rowData["wave"] == "" ? '未知' : rowData["wave"]}',
            style: const TextStyle(color: Color(0xFF666666))),
        const SizedBox(height: 12),
        Text('挤奶量     ${rowData["milkAmount"] == null || rowData["milkAmount"] == "" ? '未知' : rowData["milkAmount"]}',
            style: const TextStyle(color: Color(0xFF666666))),
        // const SizedBox(height: 12),
        // Text(
        //   '设备唯一码: ${rowData["algorithmCode"]}',
        //   style: const TextStyle(color: Color(0xFF666666)),
        // ),
        const SizedBox(height: 12),
        const Divider(height: 0.5, color: Color(0xFFE2E2E2)),
        const SizedBox(height: 12),
        Text(
          '识别时间: ${rowData["identifyTime"]}',
          style: const TextStyle(color: Color(0xFF999999)),
        ),
      ],
    );
  }
}