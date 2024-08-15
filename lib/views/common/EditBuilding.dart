import 'package:flutter/material.dart';
import 'package:easy_collect/api/building.dart';
import 'package:easy_collect/widgets/OrgTreeSelector/OrgTreeSelector.dart';
import 'package:easy_collect/widgets/BuildingSelector/BuildingSelector.dart';

class EditBuildingPage extends StatefulWidget {
  const EditBuildingPage({super.key});

  @override
  State<EditBuildingPage> createState() => _EditBuildingPageState();
}

class _EditBuildingPageState extends State<EditBuildingPage> {
  final TextEditingController _orgController = TextEditingController();
  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _currentNumController = TextEditingController();
  final TextEditingController _initialNumController = TextEditingController();
  final TextEditingController _blockController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  final GlobalKey<OrgTreeSelectorState> _orgTreeSelectorKey = GlobalKey<OrgTreeSelectorState>();
  final GlobalKey<BuildingSelectorState> _buildingSelectorKey = GlobalKey<BuildingSelectorState>();

  String _selectedBuildingType = '正式圈舍';
  String _selectedMonitorCnt = '1';
  String _selectedAlgorithmCnt = '1';
  String? orgId;
  String? buildingId;

  @override
  void dispose() {
    _orgController.dispose();
    _buildingController.dispose();
    _currentNumController.dispose();
    _initialNumController.dispose();
    _blockController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  void _saveBuilding() async {
    // 检查必填字段是否为空
    if (_orgController.text.isEmpty ||
        _buildingController.text.isEmpty ||
        _currentNumController.text.isEmpty) {
      String missingFields = '';
      if (_orgController.text.isEmpty) missingFields += '组织, ';
      if (_buildingController.text.isEmpty) missingFields += '圈舍名称, ';
      if (_currentNumController.text.isEmpty) missingFields += '当前数量, ';
      missingFields = missingFields.substring(0, missingFields.length - 2); // 去掉最后一个逗号和空格

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('请填写以下必填字段: $missingFields')),
      );
      return;
    }

    // 构建保存数据
    Map<String, dynamic> params = {
      'orgId': orgId,
      'buildingName': _buildingController.text,
      'currentNum': _currentNumController.text,
      'initialNum': _initialNumController.text,
      'blockNum': _blockController.text,
      'type': _selectedBuildingType == '正式圈舍' ? '0' : '1',
      'monitorCnt': _selectedMonitorCnt,
      'algorithmCnt': _selectedAlgorithmCnt,
      'comment': _remarkController.text,
    };

    // 保存数据到API
    await editBuilding(params);

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
    _currentNumController.clear();
    _initialNumController.clear();
    _blockController.clear();
    _remarkController.clear();
    _selectedBuildingType = '正式圈舍';
    _selectedMonitorCnt = '1';
    _selectedAlgorithmCnt = '1';
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

  Widget _buildDropdownField(String label, String value, List<String> items, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                label,
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            Expanded(
              flex: 5,
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                underline: const SizedBox(),
                onChanged: onChanged,
                items: items.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(color: Colors.black, fontSize: 16)),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('添加圈舍'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(  // 添加 SingleChildScrollView
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
            _buildTextField('当前数量', _currentNumController, isRequired: true),
            _buildTextField('初期数量', _initialNumController),
            _buildTextField('栋别', _blockController),
            _buildDropdownField('圈舍类型', _selectedBuildingType, ['正式圈舍', '临时圈舍'], (value) {
              setState(() {
                _selectedBuildingType = value!;
              });
            }),
            _buildDropdownField('监控视频数量', _selectedMonitorCnt, ['1', '4', '9'], (value) {
              setState(() {
                _selectedMonitorCnt = value!;
              });
            }),
            _buildDropdownField('算法视频数量', _selectedAlgorithmCnt, ['1', '4', '9'], (value) {
              setState(() {
                _selectedAlgorithmCnt = value!;
              });
            }),
            _buildTextField('备注', _remarkController),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveBuilding,
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
}