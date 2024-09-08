import 'package:easy_collect/api/precisionBreeding.dart';
import 'package:easy_collect/api/weight.dart';
import 'package:easy_collect/models/dropDownMenu/DropDownMenu.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/utils/OverlayManager.dart';
import 'package:easy_collect/widgets/List/ListCard.dart';
import 'package:easy_collect/widgets/List/PickerPastureWidget.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeightPage extends ConsumerStatefulWidget {
  const WeightPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WeightPageState();
}

class _WeightPageState extends ConsumerState<WeightPage> {
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
        title: const Text('体重信息'),
      ),
      body: Container(
        color: const Color(0xFFF1F5F9),
        child: Column(
          children: [
            Expanded(
              child: weightInfoTree.when(
                data: (data) {
                  return ListWidget<WeightPageFamily>(
                    pasture: PastureModel(
                      selectLast: SelectLast.pasture,
                      field: 'orgId',
                      options: data,
                    ),
                    provider: weightPageProvider,
                    filterList: [
                      DropDownMenuModel(name: '牛耳标', layerLink: LayerLink(), fieldName: 'no', widget: WidgetType.input),
                      DropDownMenuModel(name: '测定日期', layerLink: LayerLink(), fieldName: 'startDate,endDate', widget: WidgetType.dateRangePicker),
                    ],
                    builder: (rowData) {
                      return WeightItem(rowData: rowData);
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
}

class WeightItem extends StatelessWidget {
  final Map<String, dynamic> rowData;

  const WeightItem({super.key, required this.rowData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListCardTitle(
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF5D8FFD),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  '${rowData["dataValue"]}KG',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                rowData["animalNo"],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          hasDetail: false,
        ),
        ListCardCell(
          label: '与上一次的体重变化值',
          value: rowData["changeWeight"],
        ),
        ListCardCell(
          label: '日增重',
          value: rowData["dailyGain"],
        ),
        ListCardCellTime(
          label: '测定日期',
          value: rowData["date"],
        ),
      ],
    );
  }
}
