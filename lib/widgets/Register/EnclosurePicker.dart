

import 'package:easy_collect/api/register.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/views/insurance/StandardVerification.dart';
import 'package:easy_collect/widgets/Form/PickerFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_picker/picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnclosurePickerWidget extends ConsumerStatefulWidget {
  final InputDecoration? decoration;
  final PickerEditingController controller;
  final List<EnclosureModel>? options;
  const EnclosurePickerWidget({super.key, this.decoration, required this.controller, this.options});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EnclosurePickerWidgetState();
}

class _EnclosurePickerWidgetState extends ConsumerState<EnclosurePickerWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.addListener(() {

    });
    super.initState();
  }


  List<PickerItem<String>> getPickerData(List<EnclosureModel> data) {
    return data.map((EnclosureModel e) {
      return PickerItem<String>(
        text: Text(e.name),
        value: e.id,
        children: getPickerData(e.children ?? [])
      );
    }).toList();
  }
  String getName(List<EnclosureModel> enclosureList, List<String> values) {
    List<EnclosureModel> data = enclosureList.map((e) => e).toList();
    return values.map((e) {
      EnclosureModel item = data.firstWhere((element) => element.id == e);
      if (item.children != null) data = item.children!.map((e) => e).toList();
      return item.name;
    }).join('/');
  }
  bool lastIsBld(List<EnclosureModel> enclosureList, String id) {
    return enclosureList.any((enclosure) {
      if(enclosure.id == id && enclosure.nodeType == 'bld') {
        return true;
      }
      if (enclosure.children != null) {
        return lastIsBld(enclosure.children!, id);
      }
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<EnclosureModel> options = [];
    if (widget.options != null) {
      options = widget.options!;
    } else {
      final AsyncValue<List<EnclosureModel>> enclosureList = ref.watch(enclosureListProvider);
      options = enclosureList.value ?? [];
    }

    return TextFormField(
      decoration: widget.decoration,
      controller: _controller,
      readOnly: true,
      onTap: () {
        FocusScope.of(context).unfocus(); 
        Picker picker = Picker(
          height: 300,
          confirmText: '确定',
          cancelText: '取消',
          adapter: PickerDataAdapter(
            data: getPickerData(options) , 
          ),
          changeToFirst: true,
          textAlign: TextAlign.left,
          columnPadding: const EdgeInsets.all(0),
          onConfirm: (Picker picker, List value) {
            List<String> values = picker.getSelectedValues().cast<String>();
            if (!lastIsBld(options, values.last)) {
              EasyLoading.showError('改选项最后一级不是圈舍');
              return;
            }
            if (values.length < 2) {
              EasyLoading.showError('数据错误，选项低于2级');
              return;
            }
            String text = getName(options, values);
            _controller.text = text;
            widget.controller.value = values;
            widget.controller.text = text;
          }
        );
        if (scaffoldKey.currentState != null) {
          picker.show(scaffoldKey.currentState!);
        }
      },
    );
  }
}