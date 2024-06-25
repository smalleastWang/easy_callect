import 'package:collection/collection.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/utils/OverlayManager.dart';
import 'package:easy_collect/utils/colors.dart';
import 'package:easy_collect/utils/dialog.dart';
import 'package:flutter/material.dart';

enum ActionType {
  province(1, '请选择省份'),
  city(2, '请选择市'),
  pasture(3, '请选择牧场');
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
  const PickerPastureWidget({super.key, required this.options});

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
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7F9),
        borderRadius: BorderRadius.circular(6)
      ),
      child: GestureDetector(
        onTap: () {
          overlayEntryAllRemove();
          showConfirmModalBottomSheet(
            context: context,
            title: '请选择牧场',
            contentBuilder: (BuildContext context) {
              return StatefulBuilder(builder: (context, setBottomSheetState) {
                ActionType actionType = tabs[actionIndex].type;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ...tabs.mapIndexed((index, e) {
                          return GestureDetector(
                            onTap: () {
                              setBottomSheetState(() {
                                actionIndex = index;
                              });
                            },
                            child: Row(
                              children: [
                                Text(
                                  e.name ?? e.type.label,
                                  style: TextStyle(color: actionType == e.type ? MyColors.primaryColor : null),
                                ),
                                const Icon(Icons.keyboard_arrow_down_rounded)
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: tabs[actionIndex].options?.map((e) {
                        return GestureDetector(
                          onTap: () {
                            if (tabs[actionIndex].id != null) {
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
                );
              });
            },
            onConfirm: () {
              setState(() {
                text = tabs.map((e) => e.name).where((e) => e != null).join('/');
              });
            }
          );
        },
        behavior: HitTestBehavior.opaque,
        child: Text(text ?? '请选择牧场/圈舍'),
      ),
    );
  }
}