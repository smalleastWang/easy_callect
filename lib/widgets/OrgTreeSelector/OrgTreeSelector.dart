import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_collect/api/common.dart';
import 'package:easy_collect/models/common/Area.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class OrgTreeSelector extends ConsumerStatefulWidget {
  final bool enableCitySelection;
  final bool enableOrgSelection;
  final bool requireFinalSelection; // 新增参数
  final void Function(String? province, String? city, String? org, String? provinceName, String? cityName, String? orgName) onAreaSelected;

  const OrgTreeSelector({
    super.key,
    this.enableCitySelection = true,
    this.enableOrgSelection = true,
    this.requireFinalSelection = false, // 默认值为 false
    required this.onAreaSelected,
  });

  @override
  OrgTreeSelectorState createState() => OrgTreeSelectorState();
}

class OrgTreeSelectorState extends ConsumerState<OrgTreeSelector> {
  String? selectedProvinceId;
  String? selectedCityId;
  String? selectedOrgId;

  AreaModel? selectedProvince;
  AreaModel? selectedCity;
  AreaModel? selectedOrg;

  List<AreaModel> provinces = [];
  List<AreaModel> cities = [];
  List<AreaModel> orgs = [];

  List<AreaModel> filteredCities = [];
  List<AreaModel> filteredOrgs = [];

  @override
  void initState() {
    super.initState();
    _loadAreaData();
  }

  Future<void> _loadAreaData() async {
    final areaList = await ref.read(orgTreeProvider.future);

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
      orgs = flatAreas.where((area) => area.parentId != null && cities.any((city) => city.id == area.parentId)).toList();
    });
  }

  void show() {
    _showSelectionSheet(context);
  }

  void _showSelectionSheet(BuildContext context) {
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
                selectedOrg = null;
                selectedOrgId = null;
                filteredCities = selectedProvinceId != null
                    ? cities.where((city) => city.parentId == selectedProvinceId).toList()
                    : [];
                filteredOrgs = [];
              });
            }

            void onCitySelected(AreaModel? city) {
              setState(() {
                selectedCity = city;
                selectedCityId = city?.id;
                selectedOrg = null;
                selectedOrgId = null;
                filteredOrgs = selectedCityId != null
                    ? orgs.where((org) => org.parentId == selectedCityId).toList()
                    : [];
              });
            }

            void onOrgSelected(AreaModel? org) {
              setState(() {
                selectedOrg = org;
                selectedOrgId = org?.id;
              });
            }

            bool isFinalSelectionValid() {
              return !(widget.requireFinalSelection &&
                  ((widget.enableCitySelection && selectedCity == null) ||
                   (widget.enableOrgSelection && selectedOrg == null)));
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
                              '选择牧场',
                              style: TextStyle(color: Color(0xFF000000), fontSize: 16),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: isFinalSelectionValid() ? () {
                            widget.onAreaSelected(
                              selectedProvinceId,
                              selectedCityId,
                              selectedOrgId,
                              selectedProvince?.name,
                              selectedCity?.name,
                              selectedOrg?.name,
                            );
                            Navigator.of(context).pop();
                          } : () {
                            if(selectedCityId == null) {
                              EasyLoading.showToast('请选择城市', toastPosition: EasyLoadingToastPosition.bottom);
                              return;
                            }
                            if(selectedOrgId == null) {
                              EasyLoading.showToast('请选择牧场', toastPosition: EasyLoadingToastPosition.bottom);
                              return;
                            }
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
                        if (widget.enableCitySelection && filteredCities.isNotEmpty)
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
                        if (widget.enableOrgSelection && filteredOrgs.isNotEmpty)
                          Expanded(
                            child: ListView(
                              children: filteredOrgs.map((area) {
                                return ListTile(
                                  title: Text(area.name),
                                  selected: area.id == selectedOrg?.id,
                                  onTap: () {
                                    onOrgSelected(area);
                                  },
                                );
                              }).toList(),
                            ),
                          ),
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
    return Container(); // 用于占位符，实际不需要显示任何东西
  }
}