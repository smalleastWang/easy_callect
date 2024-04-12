import 'package:flutter/material.dart';
import 'package:easy_collect/models/user/UserInfo.dart';
import 'package:easy_collect/api/my.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});
  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  // 用户信息模型
  late UserInfoModel _userInfo;

  // 控制器
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  String _selectedGender = '';

  @override
  void initState() {
    super.initState();
    // 初始化页面数据
    _getUserInfo();
  }

  // 从接口获取用户信息
  void _getUserInfo() async {
    try {
      // 调用接口获取用户信息
      UserInfoModel userInfo = await MyApi.getUserInfoApi();
      setState(() {
        // 将获取的用户信息填充到控制器中
        _userInfo = userInfo;
        _nameController.text = userInfo.name ?? '';
        _phoneNumberController.text = userInfo.phone ?? '';
        _nicknameController.text = userInfo.nickname ?? '';
        _emailController.text = userInfo.email ?? '';
        _birthdayController.text = userInfo.birthday ?? '';
        _selectedGender = userInfo.gender ?? '';
      });
    } catch (e) {
      // 处理错误
      print('Error fetching user info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('用户基本信息'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 账号信息（从接口获取）
            Text(
              '账号: ${_userInfo.account}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            // 姓名
            _buildTextField('姓名', _nameController),
            const SizedBox(height: 10),
            // 手机号
            _buildTextField('手机号', _phoneNumberController),
            const SizedBox(height: 10),
            // 昵称
            _buildTextField('昵称', _nicknameController),
            const SizedBox(height: 10),
            // 性别
            _buildGenderSelection(),
            const SizedBox(height: 10),
            // 生日
            _buildBirthdayPicker(),
            const SizedBox(height: 10),
            // 邮箱
            _buildTextField('邮箱', _emailController),
            const SizedBox(height: 20),
            // 保存按钮
            ElevatedButton(
              onPressed: () {
                // 在这里处理保存操作
                _saveChanges();
              },
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '性别',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Radio<String>(
              value: '男',
              groupValue: _selectedGender,
              onChanged: (value) {
                setState(() {
                  _selectedGender = value!;
                });
              },
            ),
            const Text('男'),
            Radio<String>(
              value: '女',
              groupValue: _selectedGender,
              onChanged: (value) {
                setState(() {
                  _selectedGender = value!;
                });
              },
            ),
            const Text('女'),
          ],
        ),
      ],
    );
  }

  Widget _buildBirthdayPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '生日',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () {
            _selectDate(context);
          },
          child: AbsorbPointer(
            child: TextFormField(
              controller: _birthdayController,
              decoration: const InputDecoration(
                labelText: '选择日期',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('zh', 'CN')
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _birthdayController.text = picked.toString().split(' ')[0];
      });
    }
  }

  void _saveChanges() {
    // 检查姓名字段是否为空
    if (_nameController.text.isEmpty) {
      // 如果姓名字段为空，显示提示消息
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入姓名')),
      );
    } else {
      // 如果姓名字段不为空，保存更改
      // 你可以调用接口将更改保存到服务器
      // 例如：saveUserInfoApi(_nameController.text, _phoneNumberController.text, ...)
      // 保存成功提示
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('保存成功')),
      );
    }
  }
}