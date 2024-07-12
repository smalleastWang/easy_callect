import 'package:easy_collect/api/inventory.dart';
import 'package:easy_collect/enums/route.dart';
import 'package:easy_collect/widgets/Button/BlockButton.dart';
import 'package:easy_collect/widgets/List/ListCard.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_picker/picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SetTimePage extends ConsumerStatefulWidget {
  final RouteEnum route;
  const SetTimePage(this.route, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SetTimePageState();
}

class _SetTimePageState extends ConsumerState<SetTimePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int? hour;
  int? minute;
  List<String> selectIds = []; 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(widget.route.title),
        actions: [
          TextButton(
            onPressed: () {
              if (hour == null || minute == null) {
                EasyLoading.showToast('请选择时间');
                return;
              }
              if (selectIds.isEmpty) {
                EasyLoading.showToast('请选择修改的牧场');
                return;
              }
              setInventoryTimeApi({
                'hour': hour,
                'minute': minute,
                'orgIds': selectIds,
                'type':  widget.route == RouteEnum.inventorySetTime ? 0 : 1
              });
            },
            child: const Text('提交')
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: BlockButton(
              onPressed: () {
                if (selectIds.isEmpty) {
                  EasyLoading.showToast('请选择修改的牧场');
                  return;
                }
                Picker picker = Picker(
                  confirmText: '确定',
                  cancelText: '取消',
                  adapter: DateTimePickerAdapter(type: PickerDateTimeType.kHM),
                  onConfirm: (Picker picker, List value) {
                    setState(() {
                      hour = value[0];
                      minute = value[1];
                    });
                    print((picker.adapter as DateTimePickerAdapter).value);
                  }
                );
                picker.show(scaffoldKey.currentState!);
              },
              text: hour != null && minute != null ? '$hour时$minute分' : '设置盘点时间',
            )
          ),
          Expanded(
            child: ListWidget(
              provider: inventoryOrgListApiProvider,
              builder: (data) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: data['selected'],
                      onChanged: (value) {
                        if (value == false) {
                          selectIds.remove(data['id'].toString());
                        } else {
                          selectIds.add(data['id'].toString());
                        }
                        setState(() {
                          data['selected'] = !data['selected'];
                        });
                      },
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListCardCell(label: '牧场', value: data['orgName'], labelWidth: 80),
                        ListCardCell(label: '盘点时间', value: data['checkTime'], labelWidth: 80)
                      ],
                    )
                  ],
                );
              },
            )
          ),
          
        ],
      ),
    );
  }
}