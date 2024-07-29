import 'package:easy_collect/api/insurance.dart';
import 'package:flutter/material.dart';

class EditInsuranceApplicantPage extends StatefulWidget {
  const EditInsuranceApplicantPage({super.key});

  @override
  State<EditInsuranceApplicantPage> createState() => _EditInsuranceApplicantPageState();
}

class _EditInsuranceApplicantPageState extends State<EditInsuranceApplicantPage> {
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _bankAccountController = TextEditingController();
  final TextEditingController _bankAddressController = TextEditingController();
  final TextEditingController _bankCityController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _bankProvinceController = TextEditingController();
  final TextEditingController _breedingBaseController = TextEditingController();
  final TextEditingController _farmerAddressController = TextEditingController();
  final TextEditingController _farmerNameController = TextEditingController();
  final TextEditingController _idCardNumberController = TextEditingController();
  final TextEditingController _isPovertyController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _otherCardNumberController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _saveInsuranceApplicant() async {
    // 检查必填字段是否为空
    if (_accountNameController.text.isEmpty) {
      _showError('请填写账户名称');
      return;
    }
    if (_bankAccountController.text.isEmpty) {
      _showError('请填写银行账号');
      return;
    }
    if (_bankAddressController.text.isEmpty) {
      _showError('请填写银行地址');
      return;
    }
    if (_bankCityController.text.isEmpty) {
      _showError('请填写银行所在市');
      return;
    }
    if (_bankNameController.text.isEmpty) {
      _showError('请填写银行名称');
      return;
    }
    if (_bankProvinceController.text.isEmpty) {
      _showError('请填写银行所在省');
      return;
    }
    if (_breedingBaseController.text.isEmpty) {
      _showError('请填写养殖基地');
      return;
    }
    if (_farmerAddressController.text.isEmpty) {
      _showError('请填写农户地址');
      return;
    }
    if (_farmerNameController.text.isEmpty) {
      _showError('请填写农户名称');
      return;
    }
    if (_idCardNumberController.text.isEmpty) {
      _showError('请填写身份证号码');
      return;
    }
    if (_isPovertyController.text.isEmpty) {
      _showError('请填写是否贫困户');
      return;
    }
    if (_latitudeController.text.isEmpty) {
      _showError('请填写纬度');
      return;
    }
    if (_longitudeController.text.isEmpty) {
      _showError('请填写经度');
      return;
    }
    if (_otherCardNumberController.text.isEmpty) {
      _showError('请填写其他证件号码');
      return;
    }
    if (_phoneController.text.isEmpty) {
      _showError('请填写联系电话');
      return;
    }
    if (_remarksController.text.isEmpty) {
      _showError('请填写备注');
      return;
    }

    // 构建保存数据
    Map<String, dynamic> params = {
      'accountName': _accountNameController.text,
      'bankAccount': _bankAccountController.text,
      'bankAddress': _bankAddressController.text,
      'bankCity': _bankCityController.text,
      'bankName': _bankNameController.text,
      'bankProvince': _bankProvinceController.text,
      'breedingBase': _breedingBaseController.text,
      'farmerAddress': _farmerAddressController.text,
      'farmerName': _farmerNameController.text,
      'idCardNumber': _idCardNumberController.text,
      'isPoverty': _isPovertyController.text,
      'latitude': _latitudeController.text,
      'longitude': _longitudeController.text,
      'otherCardNumber': _otherCardNumberController.text,
      'phone': _phoneController.text,
      'remarks': _remarksController.text,
    };

    // 保存数据到API
    await editInsuranceApplicant(params);

    // 保存成功提示
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('保存成功')),
    );

    Navigator.of(context).pop(true);

    // 清空表单
    setState(() {
      _accountNameController.clear();
      _bankAccountController.clear();
      _bankAddressController.clear();
      _bankCityController.clear();
      _bankNameController.clear();
      _bankProvinceController.clear();
      _breedingBaseController.clear();
      _farmerAddressController.clear();
      _farmerNameController.clear();
      _idCardNumberController.clear();
      _isPovertyController.clear();
      _latitudeController.clear();
      _longitudeController.clear();
      _otherCardNumberController.clear();
      _phoneController.clear();
      _remarksController.clear();
    });
  }

  Widget _buildTextField(String label, TextEditingController controller) {
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
              child: TextField(
                controller: controller,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('添加投保人'),
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
            _buildTextField('账户名称', _accountNameController),
            _buildTextField('银行账号', _bankAccountController),
            _buildTextField('银行地址', _bankAddressController),
            _buildTextField('银行所在市', _bankCityController),
            _buildTextField('银行名称', _bankNameController),
            _buildTextField('银行所在省', _bankProvinceController),
            _buildTextField('养殖基地', _breedingBaseController),
            _buildTextField('农户地址', _farmerAddressController),
            _buildTextField('农户名称', _farmerNameController),
            _buildTextField('身份证号码', _idCardNumberController),
            _buildTextField('是否贫困户', _isPovertyController),
            _buildTextField('纬度', _latitudeController),
            _buildTextField('经度', _longitudeController),
            _buildTextField('其他证件号码', _otherCardNumberController),
            _buildTextField('联系电话', _phoneController),
            _buildTextField('备注', _remarksController),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveInsuranceApplicant,
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