import 'package:easy_collect/models/dict/Dict.dart';
import 'package:easy_collect/models/dropDownMenu/DropDownMenu.dart';
import 'package:flutter/material.dart';

class Option extends DictModel {
  bool check;
  Option({required this.check, required super.dictLabel, required super.dictValue});
}

class DropDownMenu extends StatefulWidget {
  final List<DropDownMenuModel> filterList;
  const DropDownMenu({super.key, required this.filterList});

  @override
  State<DropDownMenu> createState() => _DropDownMenuState();
}

class _DropDownMenuState extends State<DropDownMenu> with SingleTickerProviderStateMixin {
  int _curFilterIndex = 0;
  OverlayEntry? _overlayEntry;
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
    if (reset && _overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }

    RenderBox? renderBox;
    if (_buttonRowKey.currentContext != null) {
      renderBox = _buttonRowKey.currentContext?.findRenderObject() as RenderBox;
    }

    double left = -(renderBox!.size.width / widget.filterList.length) * index;
    _overlayEntry = OverlayEntry(
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
                              child: ListView(
                                shrinkWrap: true,
                                children: widget.filterList[index].list.asMap().entries.map((e) {
                                  int itemIndex = e.key;
                                  Option item = e.value;
                                  return _menuItem(cate: item, index: itemIndex, rootIndex: index);
                                }).toList(),
                              ),
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

    Overlay.of(context).insert(_overlayEntry!);
  }

  Widget _menuItem({required int index, required int rootIndex, required Option cate}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        for (Option item in widget.filterList[rootIndex].list) {
          item.check = false;
        }
        widget.filterList[rootIndex].list[index].check = true;
        changeOverlay(index: rootIndex, reset: true);
        _isExpanded = false;
        _animationController.reverse();
        Future.delayed(const Duration(milliseconds: 300)).then((value) {
          _overlayEntry!.remove();
          _overlayEntry = null;
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
                    if (_curFilterIndex == index || _overlayEntry == null) {
                      _isExpanded = !_isExpanded;
                      if (_isExpanded) {
                        _animationController.forward();
                      } else {
                        _animationController.reverse();
                        _overlayEntry!.remove();
                        _overlayEntry = null;
                      }
                    } else {
                      _overlayEntry!.remove();
                      _overlayEntry = null;
                    }
                    _curFilterIndex = index;
                    changeOverlay(index: index, reset: true);
                    if (_isExpanded) {
                      _maskColor = Colors.black12;
                    }
                    Future.delayed(const Duration(milliseconds: 300)).then((_) {
                      if (!_isExpanded && _overlayEntry != null) {
                        _overlayEntry!.remove();
                        _overlayEntry = null;
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
                          widget.filterList[index].name,
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