import 'package:easy_collect/widgets/OrgTreeSelector/OrgTreeSelector.dart';
import 'package:flutter/material.dart';
import 'package:easy_collect/api/aibox.dart';
import 'package:easy_collect/widgets/BuildingSelector/BuildingSelector.dart'; // 引入 BuildingSelector

enum OnlineStatus { offline, online }
enum Brand { hk, xy, dh }

extension OnlineStatusExtension on OnlineStatus {
  String get name {
    switch (this) {
      case OnlineStatus.offline:
        return '离线';
      case OnlineStatus.online:
        return '在线';
    }
  }

  String get value {
    switch (this) {
      case OnlineStatus.offline:
        return '0';
      case OnlineStatus.online:
        return '1';
    }
  }
}

extension BrandExtension on Brand {
  String get name {
    switch (this) {
      case Brand.hk:
        return '海康';
      case Brand.xy:
        return '谐云';
      case Brand.dh:
        return '大华';
    }
  }

  String get value {
    switch (this) {
      case Brand.hk:
        return 'HK';
      case Brand.xy:
        return 'XY';
      case Brand.dh:
        return 'DH';
    }
  }
}

class EditAiBoxPage extends StatefulWidget {
  const EditAiBoxPage({super.key});

  @override
  State<EditAiBoxPage> createState() => _EditAiBoxPageState();
}

class _EditAiBoxPageState extends State<EditAiBoxPage> {
  final TextEditingController _orgController = TextEditingController();
  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _boxNoController = TextEditingController();
  final GlobalKey<OrgTreeSelectorState> _orgTreeSelectorKey = GlobalKey<OrgTreeSelectorState>();
  final GlobalKey<BuildingSelectorState> _buildingSelectorKey = GlobalKey<BuildingSelectorState>();

  OnlineStatus? online;
  Brand? brand;
  String? orgId; // 用于保存选择的orgId
  String? buildingId; // 用于保存选择的buildingId

  @override
  void dispose() {
    _orgController.dispose();
    _buildingController.dispose();
    _nameController.dispose();
    _modelController.dispose();
    _boxNoController.dispose();
    super.dispose();
  }

  void _saveAiBox() async {
    // 检查必填字段是否为空
    if (_orgController.text.isEmpty ||
        _buildingController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _modelController.text.isEmpty ||
        _boxNoController.text.isEmpty) {
      String missingFields = '';
      if (_orgController.text.isEmpty) missingFields += '牧场, ';
      if (_buildingController.text.isEmpty) missingFields += '圈舍, ';
      if (_nameController.text.isEmpty) missingFields += '设备名称, ';
      if (_modelController.text.isEmpty) missingFields += '型号, ';
      if (_boxNoController.text.isEmpty) missingFields += '设备编号, ';
      missingFields = missingFields.substring(0, missingFields.length - 2); // 去掉最后一个逗号和空格

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('请填写以下必填字段: $missingFields')),
      );
      return;
    }

    // 构建保存数据
    Map<String, dynamic> params = {
      'orgId': orgId,
      'buildingId': buildingId,
      'name': _nameController.text,
      'brand': brand?.value,
      'model': _modelController.text,
      'boxNo': _boxNoController.text,
      'online': online?.value,
    };

    // 保存数据到API
    await editAIBox(params);

    // 保存成功提示
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('保存成功')),
    );

    Navigator.of(context).pop(true);

    // 清空表单
    _clearForm();
  }

  void _clearForm() {
    _orgController.clear();
    _buildingController.clear();
    _nameController.clear();
    _modelController.clear();
    _boxNoController.clear();
    online = null;
    brand = null;
    orgId = null;
    buildingId = null;
  }

  void _selectOrg() {
    _orgTreeSelectorKey.currentState?.show();
  }

  void _selectBuilding() {
    if (orgId != null) {
      _buildingSelectorKey.currentState?.show();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先选择牧场')),
      );
    }
  }

  Widget _buildTextField(String label, TextEditingController controller,
    {bool readOnly = false, Widget? suffixIcon, bool isRequired = false, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        ),
        child: GestureDetector(
          onTap: onTap,
          child: AbsorbPointer(
            absorbing: readOnly,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      if (isRequired)
                        const Text(
                          '*',
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      Text(
                        label,
                        style: const TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: TextField(
                    controller: controller,
                    readOnly: readOnly,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      suffixIcon: suffixIcon,
                    ),
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('添加AI盒子'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            _buildTextField(
              '牧场',
              _orgController,
              isRequired: true,
              suffixIcon: const Icon(Icons.arrow_forward_ios, size: 16,),
              readOnly: true,
              onTap: _selectOrg,
            ),
            _buildTextField(
              '圈舍',
              _buildingController,
              isRequired: true,
              suffixIcon: const Icon(Icons.arrow_forward_ios, size: 16,),
              readOnly: true,
              onTap: _selectBuilding,
            ),
            _buildTextField('设备名称', _nameController, isRequired: true),
            _buildDropdownField<Brand>(
              '品牌',
              Brand.values,
              isRequired: true,
              value: brand,
              onChanged: (value) {
                setState(() {
                  brand = value;
                });
              },
            ),
            _buildTextField('型号', _modelController, isRequired: true),
            _buildTextField('设备编号', _boxNoController, isRequired: true),
            _buildDropdownField<OnlineStatus>(
              '在线状态',
              OnlineStatus.values,
              isRequired: true,
              value: online,
              onChanged: (value) {
                setState(() {
                  online = value;
                });
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveAiBox,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 3,
                ),
                child: const Text('保存'),
              ),
            ),
            OrgTreeSelector(
              key: _orgTreeSelectorKey,
              enableCitySelection: true,
              enableOrgSelection: true,
              requireFinalSelection: true,
              onAreaSelected: (provinceId, cityId, orgId, provinceName, cityName, orgName) {
                setState(() {
                  this.orgId = orgId;
                  _orgController.text = orgName!;
                  // 清空已选择的圈舍
                  buildingId = null;
                  _buildingController.clear();
                });
              },
            ),
            if (orgId != null)
              BuildingSelector(
                key: _buildingSelectorKey,
                orgId: orgId!,
                onBuildingSelected: (building) {
                  setState(() {
                    buildingId = building?.id;
                    _buildingController.text = building?.buildingName ?? '';
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField<T>(
    String label,
    List<T> options, {
    required bool isRequired,
    T? value,
    required void Function(T?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  if (isRequired)
                    const Text(
                      '*',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  Text(
                    label,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<T>(
                  value: value,
                  isExpanded: true,
                  items: options.map((option) {
                    return DropdownMenuItem<T>(
                      value: option,
                      child: Text(option is OnlineStatus ? option.name : (option as Brand).name),
                    );
                  }).toList(),
                  onChanged: onChanged,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}