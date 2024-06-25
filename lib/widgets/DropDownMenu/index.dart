import 'package:easy_collect/models/dict/Dict.dart';
import 'package:easy_collect/models/dropDownMenu/DropDownMenu.dart';
import 'package:easy_collect/utils/OverlayManager.dart';
import 'package:easy_collect/widgets/Button/BlockButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/picker.dart';

class Option extends DictModel {
  bool check;
  Option({required this.check, required super.dictLabel, required super.dictValue});
}

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
                    print((picker.adapter as DateTimePickerAdapter).value);
                    DateTime? date = (picker.adapter as DateTimePickerAdapter).value;
                    if (date == null) return;
                    state(() {
                      if (title == '开始时间') {
                        firstDate = '${date.year}-${date.month}-${date.day}';
                      } else {
                        lastDate = '${date.year}-${date.month}-${date.day}';
                      }
                    });
                    
                  },
                );
                dropDownMenuRangeDateOverlayEntry = OverlayEntry(builder: (context) {
                  return  Stack(
                    children: [
                      Positioned(  
                        bottom: 0,  
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(onPressed: () {
                                    dropDownMenuRangeDateOverlayEntryRemove();
                                  }, child: const Text('取消')),
                                  Text(title),
                                  TextButton(onPressed: () {
                                    ps.onConfirm?.call(ps, ps.selecteds);
                                  }, child: const Text('确认'))
                                ],
                              ),
                            ),
                            ps.makePicker()
                          ],
                        ),
                      )
                    ],
                  );
                });
                
                Overlay.of(context).insert(dropDownMenuRangeDateOverlayEntry!);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12)
                ),
                child: Expanded(
                  child: Text((title == '开始时间' ? firstDate : lastDate) ?? title),
                ),
              )
            ),
          );
        });
        
      }
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                datePicker('开始时间'),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  child: const Text('-', style: TextStyle(fontSize: 16)),
                ),
                datePicker('结束时间'),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    _isExpanded = false;
                    overlayEntryAllRemove();
                    firstDate = null;
                    lastDate = null;
                    widget.onChange(data.fieldName, '$firstDate,$lastDate');
                    data.selectText = null;
                  },
                  child: const Text('清除'),
                ),
                TextButton(
                  onPressed: () {
                    _isExpanded = false;
                    overlayEntryAllRemove();
                    widget.onChange(data.fieldName, '$firstDate,$lastDate');
                    data.selectText = '$firstDate-$lastDate';
                  },
                  child: const Text('确定'),
                ),
              ],
            
            )
          ],
        ),
      );
    }
    return ListView(
      shrinkWrap: true,
      children: data.list.asMap().entries.map((e) {
        int itemIndex = e.key;
        Option item = e.value;
        return _menuItem(cate: item, index: itemIndex, rootIndex: index);
      }).toList(),
    );
  }

  Widget _menuItem({required int index, required int rootIndex, required Option cate}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        DropDownMenuModel formItem = widget.filterList[rootIndex];
        for (Option item in formItem.list) {
          item.check = false;
        }
        formItem.list[index].check = true;
        formItem.selectText = formItem.list[index].dictLabel;
        changeOverlay(index: rootIndex, reset: true);
        widget.onChange(formItem.fieldName, formItem.list[index].dictValue);
        _isExpanded = false;
        _animationController.reverse();
        Future.delayed(const Duration(milliseconds: 300)).then((value) {
          overlayEntryAllRemove();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        height: 40,
        alignment: Alignment.topLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              cate.dictLabel,
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
                      _isExpanded = !_isExpanded;
                      if (_isExpanded) {
                        _animationController.forward();
                      } else {
                        _animationController.reverse();
                        overlayEntryAllRemove();
                      }
                    } else {
                      overlayEntryAllRemove();
                    }
                    _curFilterIndex = index;
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
                  child: SizedBox(
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.filterList[index].selectText ?? widget.filterList[index].name,
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
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