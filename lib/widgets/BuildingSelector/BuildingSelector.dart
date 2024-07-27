import 'dart:async'; // 引入 Timer
import 'package:easy_collect/api/common.dart';
import 'package:easy_collect/models/buildings/building.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class BuildingSelector extends ConsumerStatefulWidget {
  final String orgId;
  final void Function(Building? selectedBuilding) onBuildingSelected;

  const BuildingSelector({
    super.key,
    required this.orgId,
    required this.onBuildingSelected,
  });

  @override
  BuildingSelectorState createState() => BuildingSelectorState();
}

class BuildingSelectorState extends ConsumerState<BuildingSelector> {
  Building? selectedBuilding;
  List<Building> buildings = [];
  List<Building> filteredBuildings = [];
  late TextEditingController _filterController;
  Timer? _debounce;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadBuildings();
    _filterController = TextEditingController();
    _scrollController.addListener(() {
      // 取消焦点
      FocusScope.of(context).unfocus();
    });
  }

  @override
  void dispose() {
    _filterController.dispose();
    _debounce?.cancel(); // 取消计时器
    _scrollController.dispose(); // 释放ScrollController
    super.dispose();
  }

  Future<void> _loadBuildings() async {
    try {
      List<Building> buildingList = await ref.read(buildingProvider(widget.orgId).future);
      setState(() {
        buildings = buildingList;
        filteredBuildings = buildings;
      });
    } catch (e) {
      EasyLoading.showError('加载圈舍数据失败');
    }
  }

  void show() {
    setState(() {
      filteredBuildings = buildings.toList();
      _filterController.clear();
    });
    _showSelectionSheet(context);
  }

  void _showSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: StatefulBuilder(
            builder: (context, setState) {
              void onBuildingSelected(Building? building) {
                setState(() {
                  selectedBuilding = building;
                });
              }

              void onFilterTextChanged(String text) {
                if (_debounce?.isActive ?? false) _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 300), () {
                  setState(() {
                    filteredBuildings = buildings
                        .where((building) => building.buildingName != null && building.buildingName!.contains(text))
                        .toList();
                  });
                });
              }

              return FractionallySizedBox(
                heightFactor: 0.6,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          const Expanded(
                            child: Center(
                              child: Text(
                                '选择圈舍',
                                style: TextStyle(color: Color(0xFF000000), fontSize: 16),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              widget.onBuildingSelected(selectedBuilding);
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              '确定',
                              style: TextStyle(color: Color(0xFF3B81F2), fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        onChanged: onFilterTextChanged,
                        controller: _filterController,
                        decoration: InputDecoration(
                          hintText: '请输入圈舍名称',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(color: Color(0xFFF5F7F9)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(color: Color(0xFFF5F7F9)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(color: Color(0xFF5D8FFD)),
                          ),
                          fillColor: const Color(0xFFF5F7F9),
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          controller: _scrollController,
                          itemCount: filteredBuildings.length,
                          itemBuilder: (context, index) {
                            final building = filteredBuildings[index];
                            return GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                onBuildingSelected(building);
                              },
                              onPanStart: (details) {
                                FocusScope.of(context).unfocus();
                              },
                              child: ListTile(
                                title: Text(building.buildingName ?? '未知'),
                                selected: building.id == selectedBuilding?.id,
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // 用于占位符，实际不需要显示任何东西
  }
}