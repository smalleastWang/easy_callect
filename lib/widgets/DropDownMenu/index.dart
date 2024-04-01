

import 'package:easy_collect/models/dict/Dict.dart';
import 'package:easy_collect/models/dropDownMenu/DropDownMenu.dart';
import 'package:flutter/material.dart';

class DropDownMenu extends StatefulWidget {
  const DropDownMenu({super.key});

  @override
  State<DropDownMenu> createState() => _DropDownMenuState();
}

class _DropDownMenuState extends State<DropDownMenu> with SingleTickerProviderStateMixin {
  int _curFilterIndex = 0;
  OverlayEntry? _overlayEntry;
  final GlobalKey _buttonRowKey = GlobalKey();
  final List<DropDownMenuModel> _filterList = [
    DropDownMenuModel(name: '类别', list: [], layerLink: LayerLink()),
    DropDownMenuModel(name: '排序', list: [], layerLink: LayerLink()),
    DropDownMenuModel(name: '区域', list: [], layerLink: LayerLink()),
  ];
  late AnimationController _animationController;
  late Animation<double> _animation;
  Color _maskColor = Colors.black12;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    init();

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

  init() async {
    // 模拟接口获取数据
    getCateList();
    getSlotList();
  }

  void getCateList() {
    setState(() {
      _filterList[0].list = [
        DictModel(dictValue: '0', dictLabel: '全部', check: false),
        DictModel(dictValue: '1', dictLabel: '火锅', check: false),
        DictModel(dictValue: '2', dictLabel: '自助餐', check: false),
        DictModel(dictValue: '3', dictLabel: '西餐', check: false),
        DictModel(dictValue: '4', dictLabel: '烤肉', check: false),
        DictModel(dictValue: '5', dictLabel: '甜品', check: false),
        DictModel(dictValue: '6', dictLabel: '饮品', check: false),
        DictModel(dictValue: '7', dictLabel: '蛋糕', check: false),
      ];
    });
  }

  void getSlotList() {
    setState(() {
      _filterList[1].list = [
        DictModel(dictValue: '1', dictLabel: '离我最近', check: false),
        DictModel(dictValue: '2', dictLabel: '综合排序', check: false),
        DictModel(dictValue: '3', dictLabel: '价格排序', check: false),
      ];
    });
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

    double left = -(renderBox!.size.width / _filterList.length) * index;
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return CompositedTransformFollower(
          link: _filterList[index].layerLink,
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
                                children: _filterList[index].list.asMap().entries.map((e) {
                                  int itemIndex = e.key;
                                  DictModel item = e.value;
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

  Widget _menuItem({required int index, required int rootIndex, required DictModel cate}) {
    return GestureDetector(
      onTap: () {
        for (DictModel item in _filterList[rootIndex].list) {
          item.check = false;
        }
        _filterList[rootIndex].list[index].check = true;
        changeOverlay(index: rootIndex, reset: true);
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
                color: _filterList[rootIndex].list[index].check == true ? Theme.of(context).primaryColor : Colors.black87,
              ),
            ),
            Offstage(
              offstage: !(_filterList[rootIndex].list[index].check == true),
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
      children: List.generate(_filterList.length, (index) {
        return Expanded(
          child: Stack(
            children: [
              CompositedTransformTarget(
                link: _filterList[index].layerLink,
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
                          _filterList[index].name,
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