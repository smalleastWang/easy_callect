import 'package:easy_collect/api/inventory.dart';
import 'package:easy_collect/models/Inventory/HistoryData.dart';
import 'package:easy_collect/models/dropDownMenu/DropDownMenu.dart';
import 'package:easy_collect/widgets/DropDownMenu/index.dart';
import 'package:easy_collect/widgets/List/ListCard.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryData extends ConsumerStatefulWidget {
  final String buildingId;
  const HistoryData(this.buildingId, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HistoryDataState();
}

class _HistoryDataState extends ConsumerState<HistoryData> {
  final GlobalKey<ListWidgetState> listWidgetKey = GlobalKey<ListWidgetState>();
  InventoryHistoryDataVo? detail;
  @override
  void initState() {
    getHistoryData(7);
    super.initState();
  }
   getHistoryData(int intervalDays) async {
    InventoryHistoryDataVo data = await inventoryHistoryDataApi({'intervalDays': intervalDays, 'buildingId': widget.buildingId});
    setState(() {
      detail = data;
    });
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('历史数据'),
      ),
      body: Column(
        children: [
          Container(
            // height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const Text('统计天数'),
                const SizedBox(width: 8),
                DropdownMenu(
                  onSelected: (value) {
                    getHistoryData(value!);
                    listWidgetKey.currentState?.getList({'intervalDays': value});
                  },
                  initialSelection: 7,
                  inputDecorationTheme: const InputDecorationTheme(
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                    // border: OutlineInputBorder(gapPadding: 0)
                    border: InputBorder.none
                    // border: InputBorder.none
                  ),
                  dropdownMenuEntries: const [
                    DropdownMenuEntry<int>(value: 7, label: '7天'),
                    DropdownMenuEntry<int>(value: 15, label: '15天'),
                  ]
                ),
              ],
            ),
          ),
          
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 100,
                      child: Text('牧场'),
                    ),
                    Text(detail?.orgName ?? '-' )
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 100,
                      child: Text('圈舍'),
                    ),
                    Text(detail?.buildingName ?? '-' )
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 100,
                      child: Text('实际数量'),
                    ),
                    Text(detail?.actualNum ?? '-' )
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 100,
                      child: Text('盘点总数量'),
                    ),
                    Text('${detail?.inventoryNum ?? "-"}' )
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: ListWidget(
              key: listWidgetKey,
              provider: inventoryHistoryDataListApiProvider,
              // filterList: [
              //   DropDownMenuModel(
              //     name: '统计天数',
              //     list: [
              //       Option(check: false, dictLabel: '7天', dictValue: '7'),
              //       Option(check: false, dictLabel: '14天', dictValue: '14'),
              //     ], layerLink: LayerLink(), fieldName: 'state'
              //   ),
              // ],
              params: {'intervalDays': 7, 'buildingId': widget.buildingId},
              builder: (data) {
                return Column(
                  children: [
                    ListCardCell(label: '算法标识', value: data['algorithmCode'], labelWidth: 80),
                    ListCardCell(label: '次数', value: '${data['num']}', labelWidth: 80),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 80,
                          child: Text('时间'),
                        ),
                        Column(
                          children: data['times'].toString().split(',').map((e) => Text(e)).toList(),
                        ),
                        
                      ],
                    ),
                  ]
                );
              },
            )
          )
        ],
      )
    );
  }
}