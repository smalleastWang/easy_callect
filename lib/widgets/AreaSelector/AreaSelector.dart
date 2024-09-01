import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_collect/api/common.dart';
import 'package:easy_collect/models/common/Area.dart';

class AreaSelector extends ConsumerStatefulWidget {
  final bool enableCitySelection;
  final void Function(String? province, String? city)? onAreaSelected;

  const AreaSelector({
    super.key,
    this.enableCitySelection = true,
    this.onAreaSelected,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AreaSelectorState();
}

class _AreaSelectorState extends ConsumerState<AreaSelector> {
  String? selectedProvinceId;
  String? selectedCityId;

  AreaModel? selectedProvince;
  AreaModel? selectedCity;

  List<AreaModel> provinces = [];
  List<AreaModel> cities = [];

  List<AreaModel> filteredCities = [];

  @override
  void initState() {
    super.initState();
    _loadAreaData();
  }

  Future<void> _loadAreaData() async {
    final areaList = await ref.read(areaProvider.future);

    List<AreaModel> flattenAreas(List<AreaModel> areas) {
      List<AreaModel> flatList = [];
      for (var area in areas) {
        flatList.add(area);
        if (area.children != null) {
          flatList.addAll(flattenAreas(area.children!));
        }
      }
      return flatList;
    }

    setState(() {
      List<AreaModel> flatAreas = flattenAreas(areaList);

      provinces = flatAreas.where((area) => area.parentId == '0').toList();
      cities = flatAreas.where((area) => area.parentId != '0' && provinces.any((province) => province.id == area.parentId)).toList();
    });
  }

  void _showSelectionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            void onProvinceSelected(AreaModel? province) {
              setState(() {
                selectedProvince = province;
                selectedProvinceId = province?.id;
                selectedCity = null;
                selectedCityId = null;
                filteredCities = selectedProvinceId != null
                  ? cities.where((city) => city.parentId == selectedProvinceId).toList()
                  : [];
              });
            }

            void onCitySelected(AreaModel? city) {
              setState(() {
                selectedCity = city;
                selectedCityId = city?.id;
              });
            }

            void clearSelection() {
              setState(() {
                selectedProvince = null;
                selectedProvinceId = null;
                selectedCity = null;
                selectedCityId = null;
                filteredCities = [];
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
                              '选择地区',
                              style: TextStyle(color: Color(0xFF000000), fontSize: 16),
                            ),
                          ),
                        ),
                        if (selectedProvinceId != null || selectedCityId != null)
                          GestureDetector(
                            onTap: () {
                              clearSelection();
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Icon(
                                Icons.clear,
                                color: Colors.red,
                                size: 24.0,
                              ),
                            ),
                          ),
                        TextButton(
                          onPressed: () {
                            widget.onAreaSelected?.call(selectedProvinceId, selectedCityId);
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
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: ListView(
                            children: provinces.map((area) {
                              return ListTile(
                                title: Text(area.name),
                                selected: area.id == selectedProvince?.id,
                                onTap: () {
                                  onProvinceSelected(area);
                                },
                              );
                            }).toList(),
                          ),
                        ),
                        if (widget.enableCitySelection && filteredCities.isNotEmpty) ...[
                          Expanded(
                            child: ListView(
                              children: filteredCities.map((area) {
                                return ListTile(
                                  title: Text(area.name),
                                  selected: area.id == selectedCity?.id,
                                  onTap: () {
                                    onCitySelected(area);
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showSelectionSheet();
      },
      child: InputDecorator(
        decoration: InputDecoration(
          // labelText: '选择地区',
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                selectedProvince == null
                    ? '请选择省市'
                    : '${selectedProvince?.name ?? ''}${selectedCity != null ? ' / ${selectedCity?.name}' : ''}',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (selectedProvinceId != null || selectedCityId != null)
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedProvince = null;
                    selectedProvinceId = null;
                    selectedCity = null;
                    selectedCityId = null;
                  });
                  widget.onAreaSelected?.call(null, null);
                },
                child: const Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Icon(
                    Icons.clear,
                    color: Colors.red,
                    size: 20.0,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
