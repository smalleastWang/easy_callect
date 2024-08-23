import 'package:easy_collect/api/insurance.dart';
import 'package:easy_collect/enums/route.dart';
import 'package:easy_collect/widgets/InsuranceApplicantSelector/InsuranceApplicantSelector.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InsuranceDetailAddPage extends StatefulWidget {
  final GoRouterState? state;
  const InsuranceDetailAddPage({super.key, this.state});

  @override
  State<InsuranceDetailAddPage> createState() => _InsuranceDetailAddPageState();
}

class _InsuranceDetailAddPageState extends State<InsuranceDetailAddPage> {
  late GoRouterState state;
  final GlobalKey<InsuranceApplicantSelectorState> _applicantSelectorKey = GlobalKey<InsuranceApplicantSelectorState>();
  late final Map<String, dynamic>? policy;
  final List<Map<String, dynamic>>? selectedAnimalArr = [];

  @override
  void initState() {
    super.initState();
    if (widget.state != null && widget.state!.extra != null) {
      policy = widget.state!.extra as Map<String, dynamic>;
      setState(() {
        _policyNoController.text = policy!['policyNo'] ?? '';
      });
    }
  }

  void _selectApplicant() {
    _applicantSelectorKey.currentState?.show();
  }

  void _navigateTo(String path) async {
    List<Map<String, dynamic>>? selectedAnimalArr = await context.push(path);
    print('-----result-----: $selectedAnimalArr');
    String algorithmCodes = selectedAnimalArr!.map((animal) => animal["algorithmCode"])
      .join(',');
    setState(() {
      selectedAnimalArr = selectedAnimalArr;
      _algorithmCodeController.text = algorithmCodes;
      _startNoController.text = selectedAnimalArr![0]["no"] ?? '';
      _endNoController.text = selectedAnimalArr![selectedAnimalArr!.length - 1]["no"] ?? '';
      _insuranceAmountController.text = selectedAnimalArr!.length > 1 ? '' : '1';
    });
  }

  final TextEditingController _startNoController = TextEditingController();
  final TextEditingController _endNoController = TextEditingController();
  final TextEditingController _insuranceNumController = TextEditingController();
  final TextEditingController _insuranceAmountController = TextEditingController();
  final TextEditingController _animalAgeController = TextEditingController();
  final TextEditingController _animalBreedController = TextEditingController();
  final TextEditingController _animalVarietyController = TextEditingController();
  final TextEditingController _marketValueController = TextEditingController();
  final TextEditingController _evaluateValueController = TextEditingController();
  final TextEditingController _applicantIdController = TextEditingController();
  final TextEditingController _policyNoController = TextEditingController();
  final TextEditingController _algorithmCodeController = TextEditingController();

  // 枚举值和显示文本的映射
  final Map<String, String> _coatColorOptions = {'黑': '黑', '白': '白', '红': '红', '黑白花': '黑白花', '其他': '其他'};
  final Map<String, String> _animalTypeOptions = {
    '21010102肉牛': '21010102肉牛',
    '21010101奶牛': '21010101奶牛',
    '21020204奶羊': '21020204奶羊',
    '21020204种羊': '21020204种羊',
    '210201猪': '210201猪'
  };

  String? _selectedSex = '0';
  String? _selectedHealthStatus = '0';
  String? _selectedQuarantineStatus = '0';
  String? _selectedCoatColor;
  String? _selectedAnimalType;
  String? applicantId;

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _saveInsuranceDetail() async {
    if (_startNoController.text.isEmpty ||
        _endNoController.text.isEmpty ||
        _selectedSex == null ||
        _selectedHealthStatus == null ||
        _selectedQuarantineStatus == null ||
        _selectedCoatColor == null ||
        _selectedAnimalType == null ||
        _insuranceNumController.text.isEmpty ||
        _insuranceAmountController.text.isEmpty ||
        _animalAgeController.text.isEmpty ||
        _animalBreedController.text.isEmpty ||
        _animalVarietyController.text.isEmpty ||
        _marketValueController.text.isEmpty ||
        _evaluateValueController.text.isEmpty ||
        _applicantIdController.text.isEmpty ||
        _policyNoController.text.isEmpty ||
        _algorithmCodeController.text.isEmpty) {
      _showError('请填写所有必填项');
      return;
    }

    // 构建保存数据
    Map<String, dynamic> params = {
      'startNo': _startNoController.text,
      'endNo': _endNoController.text,
      'animalSex': _selectedSex,
      'coatColor': _selectedCoatColor,
      'animalType': _selectedAnimalType,
      'isHealthy': _selectedHealthStatus,
      'isQuarantine': _selectedQuarantineStatus,
      'insuranceNum': _insuranceNumController.text,
      'insuranceAmount': _insuranceAmountController.text,
      'animalAge': _animalAgeController.text,
      'animalBreed': _animalBreedController.text,
      'animalVariety': _animalVarietyController.text,
      'marketValue': _marketValueController.text,
      'evaluateValue': _evaluateValueController.text,
      'applicantId': _applicantIdController.text,
      'policyId': policy!['id'] ?? '',
      'algorithmCode': _algorithmCodeController.text,
    };

    // 调用保存方法
    await insurancedetailAdd(params);

    // 保存成功提示
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('绑定成功')),
    );

    Navigator.of(context).pop(true);
  }

  Widget _buildRadioField(String label, String groupValue, Map<String, String> options, ValueChanged<String?> onChanged,
    {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Row(
          children: [
            IntrinsicWidth(
              child: Row(
                children: [
                  if (isRequired)
                    const Text(
                      '*',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  const SizedBox(width: 4), // 添加一个间距，让文本不贴着星号
                  Text(
                    label,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: options.entries.map((entry) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<String>(
                        value: entry.value,
                        groupValue: groupValue,
                        onChanged: onChanged,
                        activeColor: Colors.blue, // 修改选中颜色
                      ),
                      Text(entry.key),
                      const SizedBox(width: 10),
                    ],
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
        title: const Text('保单绑定'),
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
            _buildTextField('保单合同号：', _policyNoController, readOnly: true,),
            _buildTextField('选择投保人：', _applicantIdController, suffixIcon: const Icon(Icons.arrow_forward_ios, size: 16,), readOnly: true, onTap: _selectApplicant, isRequired: true),
            _buildTextField('选择牛只：', _algorithmCodeController, suffixIcon: const Icon(Icons.arrow_forward_ios, size: 16,), readOnly: true, onTap: () => _navigateTo(RouteEnum.animalSelect.fullpath), isRequired: true),
            _buildTextField('起始耳标号：', _startNoController),
            _buildTextField('终止耳标号：', _endNoController),
            _buildRadioField('性别：', _selectedSex!, {'公': '0', '母': '1'}, (value) {
              setState(() {
                _selectedSex = value;
              });
            }, isRequired: true),
            _buildRadioField('健康状况：', _selectedHealthStatus!, {'是': '0', '否': '1'}, (value) {
              setState(() {
                _selectedHealthStatus = value;
              });
            }, isRequired: true),
            _buildRadioField('是否有检验：', _selectedQuarantineStatus!, {'是': '0', '否': '1'}, (value) {
              setState(() {
                _selectedQuarantineStatus = value;
              });
            }, isRequired: true),
            _buildDropdownField('毛色：', _coatColorOptions, _selectedCoatColor, (value) {
              setState(() {
                _selectedCoatColor = value;
              });
            }, isRequired: true),
            _buildDropdownField('畜别：', _animalTypeOptions, _selectedAnimalType, (value) {
              setState(() {
                _selectedAnimalType = value;
              });
            }, isRequired: true),
            _buildTextField('畜龄：', _animalAgeController, isRequired: true),
            _buildTextField('畜种：', _animalBreedController, isRequired: true),
            _buildTextField('品种：', _animalVarietyController, isRequired: true),
            _buildTextField('承保数量：', _insuranceNumController),
            _buildTextField('单位保额：', _insuranceAmountController, isRequired: true),
            _buildTextField('市场价格：', _marketValueController, isRequired: true),
            _buildTextField('评定价格：', _evaluateValueController, isRequired: true),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveInsuranceDetail,
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
            const SizedBox(height: 30),
            InsuranceApplicantSelector(
              key: _applicantSelectorKey,
              onApplicantSelected: (applicant) {
                setState(() {
                  applicantId = applicant?.id;
                  _applicantIdController.text = applicant?.farmerName ?? '';
                });
              },
            ),
          ],
        ),
      ),
    );
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
                IntrinsicWidth(
                  child: Row(
                    children: [
                      if (isRequired)
                        const Text(
                          '*',
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      const SizedBox(width: 4), // 添加一个间距，让文本不贴着星号
                      Text(
                        label,
                        style: const TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: controller,
                    readOnly: readOnly,
                    maxLines: null, // 设置为 null 允许换行
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

  Widget _buildDropdownField<T>(String label, Map<T, dynamic> items, dynamic value, ValueChanged<dynamic> onChanged,
    {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Row(
          children: [
            IntrinsicWidth(
              child: Row(
                children: [
                  if (isRequired)
                    const Text(
                      '*',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  const SizedBox(width: 4), // 添加一个间距，让文本不贴着星号
                  Text(
                    label,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ],
              ),
            ),
            Expanded(
              child: DropdownButtonFormField<T>(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                value: value,
                onChanged: onChanged,
                items: items.keys.map((T item) {
                  return DropdownMenuItem<T>(
                    value: item,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(item.toString()),
                    ),
                  );
                }).toList(),
                dropdownColor: Colors.white, // Customize dropdown background color if needed
                menuMaxHeight: 200, // Adjust maximum height of the dropdown menu
              ),
            ),
          ],
        ),
      ),
    );
  }
}