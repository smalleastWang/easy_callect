// import 'package:easy_collect/models/dict/Dict.dart';
import 'package:easy_collect/models/common/Option.dart';
import 'package:easy_collect/models/dropDownMenu/DropDownMenu.dart';
import 'package:easy_collect/utils/OverlayManager.dart';
import 'package:easy_collect/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/picker.dart';

class DropDownMenu extends StatefulWidget {
  final List<DropDownMenuModel> filterList;
  final Function(String field, String? value) onChange;
  const DropDownMenu({super.key, required this.filterList, required this.onChange});

  @override
  State<DropDownMenu> createState() => _DropDownMenuState();
}

class _DropDownMenuState extends State<DropDownMenu> with SingleTickerProviderStateMixin {
  int _curFilterIndex = 0;
  final GlobalKey _buttonRowKey = GlobalKey();
  // final List<DropDownMenuModel> _filterList = [
  //   DropDownMenuModel(name: '类别', list: [], layerLink: LayerLink()),
  //   DropDownMenuModel(name: '排序', list: [], layerLink: LayerLink()),
  //   DropDownMenuModel(name: '区域', list: [], layerLink: LayerLink()),
  // ];
  late AnimationController _animationController;
  late Animation<double> _animation;
  Color _maskColor = Colors.black12;
  bool _isExpanded = false;

  String? firstDate;
  String? lastDate;
  String? selectedDate;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300), // 设置动画持续时间
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController); // 定义动画的值范围
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void changeOverlay({required int index, bool reset = false}) {
    // TAG: 更新OverlayEntry数据需要清空之后重新构建
    if (reset && dropDownMenuOverlayEntry != null) {
      overlayEntryAllRemove();
    }

    // 取消输入框的焦点
    FocusScope.of(context).unfocus();

    RenderBox? renderBox;
    if (_buttonRowKey.currentContext != null) {
      renderBox = _buttonRowKey.currentContext?.findRenderObject() as RenderBox;
    }

    double left = -(renderBox!.size.width / widget.filterList.length) * index;
    dropDownMenuOverlayEntry = OverlayEntry(
      builder: (context) {
        return CompositedTransformFollower(
          link: widget.filterList[index].layerLink,
          offset: Offset(left, renderBox!.size.height),
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _animation,
                    child: Container(color: _maskColor),
                  );
                },
              ),
              MediaQuery.removePadding(
                context: context,
                removeTop: true,
                removeBottom: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return SizeTransition(
                          sizeFactor: _animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, -1), // 从顶部开始
                              end: Offset.zero,
                            ).animate(_animation),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: _renderContent(widget.filterList[index], index),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

    Overlay.of(context).insert(dropDownMenuOverlayEntry!);
  }

  Widget _renderContent(DropDownMenuModel data, int index) {
    if (data.widget == WidgetType.dateRangePicker) {
      return _renderDateRangePicker(data, index);
    }
    if (data.widget == WidgetType.datePicker) {
      return _renderDatePicker(data, index);
    } 
    if (data.widget == WidgetType.input) {
      return _renderInput(data, index);
    }
    return ListView(
      shrinkWrap: true,
      children: data.list.asMap().entries.map((e) {
        int itemIndex = e.key;
        OptionModel item = e.value;
        return _menuItem(cate: item, index: itemIndex, rootIndex: index);
      }).toList(),
    );
  }
  // 输入框渲染
  Widget _renderInput(DropDownMenuModel data, int index) {
    TextEditingController inputController = TextEditingController();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF5F7F9).withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            autofocus: true,
            controller: inputController,
            style: const TextStyle(fontSize: 14), // 设置输入框字体大小为14px
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              hintText: "请输入${data.name}",
              hintStyle: const TextStyle(color: Color(0xFF282828), fontSize: 14), // 设置提示文本字体大小为14px
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(color: Color(0xFFE4E4E4)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(color: Color(0xFFE4E4E4)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(color: Color(0xFFE4E4E4)),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextButton(
                    onPressed: () {
                      _isExpanded = false;
                      overlayEntryAllRemove();
                      inputController.text = '';
                      widget.onChange(data.fieldName, null);
                      data.selectText = null;
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFCCD2E1), // 重置按钮背景颜色
                      foregroundColor: Colors.black, // 重置按钮字体颜色
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('重置', style: TextStyle(fontSize: 14)), // 设置重置按钮字体大小为14px
                  ),
                ),
              ),
              const SizedBox(width: 12), // 按钮之间的间距
              Expanded(
                child: SizedBox(
                  height: 40, // 增大按钮高度
                  child: TextButton(
                    onPressed: () {
                      _isExpanded = false;
                      overlayEntryAllRemove();
                      widget.onChange(data.fieldName, inputController.text);
                      data.selectText = inputController.text.isNotEmpty ? inputController.text : null;
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF5D8FFD), // 确定按钮背景颜色
                      foregroundColor: Colors.white, // 确定按钮字体颜色
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('确定', style: TextStyle(fontSize: 14)), // 设置确定按钮字体大小为14px
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // 区间时间选择器渲染
  Widget _renderDateRangePicker(DropDownMenuModel data, int index) {
    datePicker(String title) {
      return StatefulBuilder(builder: (context, state) {
        return Expanded(
          child: GestureDetector(
            onTap: () {
              Picker ps = Picker(
                hideHeader: true,
                adapter: DateTimePickerAdapter(type: PickerDateTimeType.kYMD, isNumberMonth: true),
                onConfirm: (Picker picker, List value) {
                  dropDownMenuRangeDateOverlayEntryRemove();
                  DateTime? date = (picker.adapter as DateTimePickerAdapter).value;
                  if (date == null) return;
                  state(() {
                    if (title == '开始时间') {
                      firstDate = '${date.year}/${date.month}/${date.day}';
                    } else {
                      lastDate = '${date.year}/${date.month}/${date.day}';
                    }
                  });
                },
              );
              dropDownMenuRangeDateOverlayEntry = OverlayEntry(builder: (context) {
                return Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        dropDownMenuRangeDateOverlayEntryRemove();
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red[400], // 取消按钮字体颜色
                                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                      ),
                                      child: const Text('取消'),
                                    ),
                                    Text(
                                      title,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        ps.onConfirm?.call(ps, ps.selecteds);
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: const Color(0xFF5D8FFD), // 确认按钮字体颜色
                                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                      ),
                                      child: const Text('确认'),
                                    ),
                                  ],
                                ),
                                ps.makePicker(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              });

              Overlay.of(context).insert(dropDownMenuRangeDateOverlayEntry!);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF5F7F9).withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                (title == '开始时间' ? firstDate : lastDate) ?? title,
                style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
              ),
            ),
          ),
        );
      });
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF5F7F9).withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              datePicker('开始时间'),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: const Text('-', style: TextStyle(fontSize: 14, color: Color(0xFF999999))),
              ),
              datePicker('结束时间'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SizedBox(
                  height: 40, // 按钮高度
                  child: TextButton(
                    onPressed: () {
                      _isExpanded = false;
                      overlayEntryAllRemove();
                      firstDate = null;
                      lastDate = null;
                      widget.onChange(data.fieldName, '$firstDate,$lastDate');
                      data.selectText = null;
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFCCD2E1), // 重置按钮背景颜色
                      foregroundColor: Colors.black, // 重置按钮字体颜色
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('重置'),
                  ),
                ),
              ),
              const SizedBox(width: 12), // 按钮之间的间距
              Expanded(
                child: SizedBox(
                  height: 40, // 按钮高度
                  child: TextButton(
                    onPressed: () {
                      if (firstDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('请选择开始时间')),
                        );
                        return;
                      }
                      if (lastDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('请选择结束时间')),
                        );
                        return;
                      }
                      _isExpanded = false;
                      overlayEntryAllRemove();
                      widget.onChange(data.fieldName, '$firstDate,$lastDate');
                      data.selectText = '$firstDate-$lastDate';
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF5D8FFD), // 确定按钮背景颜色
                      foregroundColor: Colors.white, // 确定按钮字体颜色
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('确定'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 单个时间选择器渲染
  Widget _renderDatePicker(DropDownMenuModel data, int index) {
    datePicker(String title) {
      return StatefulBuilder(builder: (context, state) {
        return Expanded(
          child: GestureDetector(
            onTap: () {
              Picker ps = Picker(
                hideHeader: true,
                adapter: DateTimePickerAdapter(type: PickerDateTimeType.kYMD, isNumberMonth: true),
                onConfirm: (Picker picker, List value) {
                  dropDownMenuSingleDateOverlayEntryRemove();
                  DateTime? date = (picker.adapter as DateTimePickerAdapter).value;
                  if (date == null) return;
                  state(() {
                    selectedDate = '${date.year}/${date.month}/${date.day}';
                  });
                },
              );
              dropDownMenuSingleDateOverlayEntry = OverlayEntry(builder: (context) {
                return Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        dropDownMenuSingleDateOverlayEntryRemove();
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red[400], // 取消按钮字体颜色
                                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                      ),
                                      child: const Text('取消'),
                                    ),
                                    Text(
                                      title,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        ps.onConfirm?.call(ps, ps.selecteds);
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: const Color(0xFF5D8FFD), // 确认按钮字体颜色
                                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                      ),
                                      child: const Text('确认'),
                                    ),
                                  ],
                                ),
                                ps.makePicker(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              });

              Overlay.of(context).insert(dropDownMenuSingleDateOverlayEntry!);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF5F7F9).withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                selectedDate ?? title,
                style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
              ),
            ),
          ),
        );
      });
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF5F7F9).withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              datePicker('请选择日期'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SizedBox(
                  height: 40, // 按钮高度
                  child: TextButton(
                    onPressed: () {
                      _isExpanded = false;
                      overlayEntryAllRemove();
                      selectedDate = null;
                      widget.onChange(data.fieldName, '$selectedDate');
                      data.selectText = null;
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFCCD2E1), // 重置按钮背景颜色
                      foregroundColor: Colors.black, // 重置按钮字体颜色
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('重置'),
                  ),
                ),
              ),
              const SizedBox(width: 12), // 按钮之间的间距
              Expanded(
                child: SizedBox(
                  height: 40, // 按钮高度
                  child: TextButton(
                    onPressed: () {
                      if (selectedDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('请选择日期')),
                        );
                        return;
                      }
                      _isExpanded = false;
                      overlayEntryAllRemove();
                      widget.onChange(data.fieldName, '$selectedDate');
                      data.selectText = selectedDate;
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF5D8FFD), // 确定按钮背景颜色
                      foregroundColor: Colors.white, // 确定按钮字体颜色
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('确定'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _menuItem({required int index, required int rootIndex, required OptionModel cate}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        DropDownMenuModel formItem = widget.filterList[rootIndex];
        for (OptionModel item in formItem.list) {
          item.check = false;
        }
        formItem.list[index].check = true;
        formItem.selectText = formItem.list[index].label;
        changeOverlay(index: rootIndex, reset: true);
        print('unlimitedNum: $unlimitedNum');
        print("value: ${formItem.list[index].value}");
        widget.onChange(formItem.fieldName, formItem.list[index].value == unlimitedNum ? '' : formItem.list[index].value);
        _isExpanded = false;
        _animationController.reverse();
        Future.delayed(const Duration(milliseconds: 300)).then((value) {
          overlayEntryAllRemove();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        height: 40,
        alignment: Alignment.topLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              cate.label,
              style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 14,
                color: widget.filterList[rootIndex].list[index].check == true ? Theme.of(context).primaryColor : Colors.black87,
              ),
            ),
            Offstage(
              offstage: !(widget.filterList[rootIndex].list[index].check == true),
              child: Icon(
                Icons.check,
                size: 16,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      key: _buttonRowKey,
      children: List.generate(widget.filterList.length, (index) {
        return Expanded(
          child: Stack(
            children: [
              CompositedTransformTarget(
                link: widget.filterList[index].layerLink,
                child: GestureDetector(
                  onTap: () {
                    if (_curFilterIndex == index || dropDownMenuOverlayEntry == null) {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                      if (_isExpanded) {
                        _animationController.forward();
                      } else {
                        _animationController.reverse();
                        overlayEntryAllRemove();
                      }
                    } else {
                      overlayEntryAllRemove();
                    }
                    setState(() {
                      _curFilterIndex = index;
                    });
                    changeOverlay(index: index, reset: true);
                    if (_isExpanded) {
                      _maskColor = Colors.black12;
                    }
                    Future.delayed(const Duration(milliseconds: 300)).then((_) {
                      if (!_isExpanded && dropDownMenuOverlayEntry != null) {
                        overlayEntryAllRemove();
                        _maskColor = Colors.transparent;
                      }
                    });
                  },
                  child: Container(
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            widget.filterList[index].selectText ?? widget.filterList[index].name,
                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.fade,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Icon(
                          _isExpanded && _curFilterIndex == index ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                          size: 20,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}