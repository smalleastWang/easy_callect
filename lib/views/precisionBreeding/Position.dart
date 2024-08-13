import 'package:easy_collect/api/precisionBreeding.dart';
import 'package:easy_collect/models/dropDownMenu/DropDownMenu.dart';
import 'package:easy_collect/utils/OverlayManager.dart';
import 'package:easy_collect/widgets/List/ListCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:easy_collect/api/position.dart';
import 'package:easy_collect/enums/Route.dart';

class PositionPage extends ConsumerStatefulWidget {
  const PositionPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PositionPageState();
}

class _PositionPageState extends ConsumerState<PositionPage> {
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
        title: Text(RouteEnum.position.title),
      ),
      body: Container(
        color: const Color(0xFFF1F5F9),
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
    return ListWidget<PositionPageFamily>(
      pasture: PastureModel(
        field: 'orgId',
        options: data,
      ),
      provider: positionPageProvider,
      filterList: [
        DropDownMenuModel(name: '牛耳标', layerLink: LayerLink(), fieldName: 'no', widget: WidgetType.input),
        DropDownMenuModel(name: '测定日期', layerLink: LayerLink(), fieldName: 'first,last', widget: WidgetType.dateRangePicker),
      ],
      builder: (positionData) {
        return PositionItem(rowData: positionData);
      },
    );
  }
}

class PositionItem extends StatelessWidget {
  final Map<String, dynamic> rowData;

  const PositionItem({super.key, required this.rowData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListCardCell(
          label: '圈舍名称',
          value: rowData["buildingName"],
          marginTop: 0,
        ),
        ListCardCell(
          label: '牛耳标',
          value: rowData["animalNo"],
        ),
        ListCardCellTime(
          label: '采集日期',
          value: rowData["inventoryDate"],
        ),
      ],
    );
  }
}