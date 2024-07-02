import 'package:collection/collection.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/utils/OverlayManager.dart';
import 'package:easy_collect/utils/colors.dart';
import 'package:easy_collect/utils/dialog.dart';
import 'package:easy_collect/widgets/Form/PickerFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

enum ActionType {
  province(1, '请选择省份'),
  city(2, '请选择市'),
  pasture(3, '请选择牧场'),
  shed(4, '请选择圈舍');
  final int value;
  final String label;

  const ActionType(this.value, this.label);

}

class PickModel {
  String? id;
  String? name;
  ActionType type;
  List<EnclosureModel>? options = [];
  PickModel({this.id, this.name, required this.type, this.options});
}

class PickerPastureWidget extends StatefulWidget {
  final List<EnclosureModel> options;
  final bool isShed;
  final Function? onChange;
  final PickerEditingController? controller;
  const PickerPastureWidget({super.key, required this.options, this.isShed = false, this.onChange, this.controller});

  @override
  State<PickerPastureWidget> createState() => _PickerPastureWidgetState();
}

class _PickerPastureWidgetState extends State<PickerPastureWidget> {
  int actionIndex = 0;
  String? text;

  List<PickModel> tabs = [];
  
  @override
  void initState() {
    for (var element in ActionType.values) {
      if (!widget.isShed && element == ActionType.shed) {
        return;
      }
      if (element == ActionType.province) {
        tabs.add(PickModel(type: element, options: widget.options));
      } else {
        tabs.add(PickModel(type: element));
      }
    }
    super.initState();
  }

  findOptionsById(List<EnclosureModel> options, String id) {
    for (var element in options) {
      if (element.id == id) {
        return element.children;
      } else if (element.children != null) {
        return findOptionsById(element.children!, id);
      }
    }
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
    return Container(
      width: double.infinity,
      padding: widget.isShed ?  const EdgeInsets.symmetric(vertical: 8) : const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: widget.isShed ? Colors.transparent : const Color(0xFFF5F7F9),
        borderRadius: BorderRadius.circular(6)
      ),
      child: GestureDetector(
        onTap: () {
          overlayEntryAllRemove();
          if (actionIndex == 0 && tabs[actionIndex].options != null && tabs[actionIndex].options!.isEmpty) {
            tabs[actionIndex].options = widget.options;
            if (widget.options.isEmpty) {
              EasyLoading.showToast('牧场信息加载中');
              return;
            }
          }
          showConfirmModalBottomSheet(
            context: context,
            title: '请选择牧场',
            contentBuilder: (BuildContext context) {
              return StatefulBuilder(builder: (context, setBottomSheetState) {
                ActionType actionType = tabs[actionIndex].type;
                return SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ...tabs.mapIndexed((index, e) {
                              return GestureDetector(
                                onTap: () {
                                  setBottomSheetState(() {
                                    actionIndex = index;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  child: Row(
                                    children: [
                                      Text(
                                        e.name ?? e.type.label,
                                        style: TextStyle(color: actionType == e.type ? MyColors.primaryColor : null, fontSize: 15),
                                      ),
                                      const Icon(Icons.keyboard_arrow_down_rounded)
                                    ],
                                  )
                                ),
                              );
                            }),
                          ],
                        )
                      ),
                      const SizedBox(height: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: tabs[actionIndex].options?.map((e) {
                          return GestureDetector(
                            onTap: () {
                              if (tabs[actionIndex].id != null && tabs[actionIndex].id == e.id) {
                                setBottomSheetState(() {
                                  tabs[actionIndex].id = null;
                                  tabs[actionIndex].name = null;
                                  if (actionIndex < tabs.length - 1) {
                                    tabs[actionIndex+1].options = [];
                                  }
                                  for (int i = actionIndex; i < tabs.length; i++) {
                                    tabs[i].id = null;
                                    tabs[i].name = null;
                                    if (i < tabs.length - 1) {
                                      tabs[i+1].options = [];
                                    }
                                  }
                                });
                                return;
                              }
                              setBottomSheetState(() {
                                tabs[actionIndex].id = e.id;
                                tabs[actionIndex].name = e.name;
                              });
                              if (actionIndex < tabs.length - 1) {
                                actionIndex++;
                                tabs[actionIndex].options = findOptionsById(widget.options, e.id);
                              }
                            },
                            child: Text(
                              e.name,
                              style: TextStyle(color: e.id == tabs[actionIndex].id ? MyColors.primaryColor : null)
                            ),
                          );
                        }).toList() ?? []
                      ),
                    ],
                  ),
                );
              });
            },
            onConfirm: () {
              if (widget.isShed  && tabs.where((element) => element.id == null).isNotEmpty) {
                EasyLoading.showError('请选至最后一级');
                return;
              }
              List<String> values = tabs.map((e) => e.id!).toList();
              if (widget.isShed  && !lastIsBld(widget.options, values.last)) {
                EasyLoading.showError('改选项最后一级不是圈舍');
                return;
              }
              setState(() {
                text = tabs.map((e) => e.name).where((e) => e != null).join('/');
              });
              if (widget.onChange != null) {
                widget.onChange!(values);
              }
              if (widget.controller != null) {
                widget.controller!.value = values ;
                widget.controller!.text = text;
              }
            }
          );
        },
        behavior: HitTestBehavior.opaque,
        child: Text(text ?? '请选择牧场/圈舍', style: const TextStyle(fontSize: 16, color: Colors.black54)),
      ),
    );
  }
}