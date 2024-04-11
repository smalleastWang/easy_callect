

import 'package:easy_collect/api/common.dart';
import 'package:easy_collect/models/common/Area.dart';
import 'package:easy_collect/views/insurance/StandardVerification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AreaPickerWidget extends ConsumerStatefulWidget {
  final Function(List<String> value) onChange;
  const AreaPickerWidget({super.key, required this.onChange});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AreaPickerWidgetState();
}

class _AreaPickerWidgetState extends ConsumerState<AreaPickerWidget> {
  List<String> penValue = [];

  @override
  void initState() {
    super.initState();
  }


  List<PickerItem<String>> getPickerData(List<AreaModel> data) {
    return data.map((AreaModel e) {
      return PickerItem<String>(
        text: Text(e.name),
        value: e.id,
        children: getPickerData(e.children ?? [])
      );
    }).toList();
  }
  String getName(areaList) {
    List<AreaModel> data = areaList.map((e) => e).toList();
    return penValue.map((e) {
      AreaModel item = data.firstWhere((element) => element.id == e);
      if (item.children != null) data = item.children!.map((e) => e).toList();
      return item.name;
    }).join('/');
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<AreaModel>> areaList = ref.watch(areaProvider);
    return GestureDetector(
      onTap: () {
          Picker picker = Picker(
          height: 300,
          confirmText: '确定',
          cancelText: '取消',
          adapter: PickerDataAdapter(
            data: getPickerData(areaList.value ?? []) , 
          ),
          changeToFirst: true,
          textAlign: TextAlign.left,
          columnPadding: const EdgeInsets.all(0),
          onConfirm: (Picker picker, List value) {
            print(value.toString());
            print(picker.getSelectedValues());
            setState(() {
              penValue = picker.getSelectedValues().cast<String>();
            });
            widget.onChange(penValue);
          }
        );
        if (scaffoldKey.currentState != null) {
          picker.show(scaffoldKey.currentState!);
        }
      },
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(vertical:10, horizontal: 6),
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(255, 126, 126, 126), width: 1),
          borderRadius: BorderRadius.circular(4)
        ),
        child: Text(penValue.isNotEmpty ? getName(areaList.value ?? []) : '选择牧场、圈舍', style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}