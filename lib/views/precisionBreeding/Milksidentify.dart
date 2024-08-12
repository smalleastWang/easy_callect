import 'package:easy_collect/api/precisionBreeding.dart';
import 'package:easy_collect/models/dropDownMenu/DropDownMenu.dart';
import 'package:easy_collect/utils/OverlayManager.dart';
import 'package:easy_collect/widgets/List/ListCard.dart';
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
  void dispose() {
    overlayEntryAllRemove();
    super.dispose();
  }
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
        ListCardCell(
          label: '挤奶位编号',
          value: rowData["milkPos"],
        ),
        // ListCardCell(
        //   label: '牧场',
        //   value: rowData["orgName"],
        // ),
        ListCardCell(
          label: '耳标号',
          value: rowData["no"],
        ),
        ListCardCell(
          label: '轮次',
          value: rowData["wave"],
        ),
        ListCardCell(
          label: '挤奶量',
          value: rowData["milkAmount"],
        ),
        // ListCardCell(
        //   label: '设备唯一码',
        //   value: rowData["algorithmCode"],
        // ),
        ListCardCellTime(
          label: '识别时间',
          value: rowData["identifyTime"],
        ),
      ],
    );
  }
}