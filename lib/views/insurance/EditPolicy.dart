import 'package:easy_collect/api/insurance.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditPolicyPage extends StatefulWidget {
  const EditPolicyPage({super.key});

  @override
  State<EditPolicyPage> createState() => _EditPolicyPageState();
}

enum PolicyState { pending, active, suspended, terminated }

extension PolicyStateExtension on PolicyState {
  String get name {
    switch (this) {
      case PolicyState.pending:
        return '待承保';
      case PolicyState.active:
        return '有效';
      case PolicyState.suspended:
        return '中止';
      case PolicyState.terminated:
        return '终止';
      default:
        return '';
    }
  }

  int get value {
    switch (this) {
      case PolicyState.pending:
        return 0;
      case PolicyState.active:
        return 1;
      case PolicyState.suspended:
        return 2;
      case PolicyState.terminated:
        return 3;
      default:
        return -1;
    }
  }
}

class _EditPolicyPageState extends State<EditPolicyPage> {
  // final TextEditingController _orgIdController = TextEditingController();
  final TextEditingController _policyNoController = TextEditingController();
  final TextEditingController _premiumController = TextEditingController();
  final TextEditingController _personController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  PolicyState _selectedState = PolicyState.pending;
  String _selectedPolicyContent = '牛只';
  DateTime? _effectiveTime;
  DateTime? _expiryTime;

  final List<String> _policyContentOptions = ['牛只', '羊只', '猪禽', '水产品', '其他'];

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _savePolicy() async {
    // 检查必填字段是否为空
    // if (_orgIdController.text.isEmpty) {
    //   _showError('请填写所属机构');
    //   return;
    // }
    if (_policyNoController.text.isEmpty) {
      _showError('请填写保险合同号');
      return;
    }
    if (_selectedPolicyContent.isEmpty) {
      _showError('请选择保险项目');
      return;
    }
    if (_premiumController.text.isEmpty) {
      _showError('请填写保险费');
      return;
    }
    if (_effectiveTime == null) {
      _showError('请填写保险合同生效日期');
      return;
    }
    if (_expiryTime == null) {
      _showError('请填写保险合同期满日期');
      return;
    }
    if (_personController.text.isEmpty) {
      _showError('请填写联系人');
      return;
    }
    if (_phoneController.text.isEmpty) {
      _showError('请填写联系电话');
      return;
    }
    if (_phoneController.text.isNotEmpty) {
      String phonePattern = r'^[1][3-9]\d{9}$';
      RegExp regExp = RegExp(phonePattern);
      if(!regExp.hasMatch(_phoneController.text)) {
          _showError('请输入有效的手机号');
      }
    }

    // 格式化日期时间
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    String effectiveTimeStr = formatter.format(_effectiveTime!);
    String expiryTimeStr = formatter.format(_expiryTime!);

    // 构建保存数据
    Map<String, dynamic> params = {
      'policyNo': _policyNoController.text,
      'policyContent': _selectedPolicyContent,
      'premium': double.tryParse(_premiumController.text),
      'effectiveTime': effectiveTimeStr,
      'expiryTime': expiryTimeStr,
      'person': _personController.text,
      'phone': _phoneController.text,
      'state': _selectedState.value,
    };

    // 保存数据到API
    await editPolicy(params);

    // 保存成功提示
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('保存成功')),
    );

    Navigator.of(context).pop(true);

    // 清空表单
    setState(() {
      // _orgIdController.clear();
      _policyNoController.clear();
      _premiumController.clear();
      _personController.clear();
      _phoneController.clear();
      _selectedState = PolicyState.pending;
      _selectedPolicyContent = '牛只';
      _effectiveTime = null;
      _expiryTime = null;
    });
  }

  Future<void> _selectDateTime(BuildContext context, Function(DateTime) onConfirm) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      );

      if (pickedTime != null) {
        final DateTime finalDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        onConfirm(finalDateTime);
      }
    }
  }

  Widget _buildDateTimeField(String label, DateTime? dateTime, Function() onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Row(
          children: [
            Flexible(
              flex: 4,
              child: Row(
                children: [
                  const Text(
                    '*',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                  Expanded(
                    child: Text(
                      label,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 6,
              child: GestureDetector(
                onTap: onTap,
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: dateTime != null
                          ? '${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}'
                          : '选择日期时间',
                    ),
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Row(
          children: [
            Flexible(
              flex: 3,
              child: Row(
                children: [
                  const Text(
                    '*',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                  Expanded(
                    child: Text(
                      label,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 7,
              child: TextField(
                controller: controller,
                keyboardType: keyboardType,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> options, String selectedValue, void Function(String?) onChanged) {
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
              child: Row(
                children: [
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
              flex: 7,
              child: DropdownButton<String>(
                value: selectedValue,
                isExpanded: true,
                underline: Container(),
                items: options.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: onChanged,
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
        title: const Text('添加保单'),
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
            // _buildTextField('所属机构', _orgIdController),
            _buildTextField('保险合同号', _policyNoController),
            _buildDropdownField('保险项目', _policyContentOptions, _selectedPolicyContent, (newValue) {
              setState(() {
                _selectedPolicyContent = newValue!;
              });
            }),
            _buildTextField('保险费', _premiumController, keyboardType: TextInputType.number),
            _buildDateTimeField('合同生效日期', _effectiveTime, () async {
              await _selectDateTime(context, (dateTime) {
                setState(() {
                  _effectiveTime = dateTime;
                });
              });
            }),
            _buildDateTimeField('合同期满日期', _expiryTime, () async {
              await _selectDateTime(context, (dateTime) {
                setState(() {
                  _expiryTime = dateTime;
                });
              });
            }),
            _buildTextField('联系人', _personController),
            _buildTextField('联系电话', _phoneController, keyboardType: TextInputType.phone),
            _buildDropdownField('保单状态', PolicyState.values.map((e) => e.name).toList(), _selectedState.name, (newValue) {
              setState(() {
                _selectedState = PolicyState.values.firstWhere((element) => element.name == newValue);
              });
            }),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _savePolicy,
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
            const SizedBox(height: 30), // 添加额外的间距
          ],
        ),
      ),
    );
  }
}
