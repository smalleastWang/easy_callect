import 'package:flutter/material.dart';
import 'package:easy_collect/models/user/UserInfo.dart';
import 'package:easy_collect/api/my.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  UserInfoModel? _userInfo;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  String _selectedGender = '男';

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    try {
      final userInfo = await MyApi.getUserInfoApi();
      setState(() {
        _userInfo = userInfo;
        _nameController.text = userInfo.name ?? '';
        _phoneNumberController.text = userInfo.phone ?? '';
        _nicknameController.text = userInfo.nickname ?? '';
        _emailController.text = userInfo.email ?? '';
        _birthdayController.text = userInfo.birthday ?? '';
        _selectedGender = userInfo.gender ?? '男';
      });
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('zh', 'CN'),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue, // button text color
              ),
            ),
          ),
          child: Localizations.override(
            context: context,
            delegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            child: child!,
          ),
        );
      },
    );
    if (picked != null) {
      setState(() {
        _birthdayController.text = picked.toString().split(' ')[0];
      });
    }
  }

  void _saveChanges() async {
    // 检查姓名字段是否为空
    if (_nameController.text.isEmpty) {
      // 如果姓名字段为空，显示提示消息
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入姓名')),
      );
      return;
    } 
    // 检查手机号格式是否正确
    if (_phoneNumberController.text.isNotEmpty && !RegExp(r'^1[0-9]{10}$').hasMatch(_phoneNumberController.text)) {
      // 如果手机号格式不正确，显示提示消息
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入正确的手机号')),
      );
      return; // 提前返回，防止继续执行保存操作
    }

    // 检查邮箱格式是否正确
    if (_emailController.text.isNotEmpty && !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(_emailController.text)) {
      // 如果邮箱格式不正确，显示提示消息
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入正确的邮箱')),
      );
      return; // 提前返回，防止继续执行保存操作
    }
    // 如果姓名字段不为空，保存更改
    Map<String, dynamic> userInfoParams = _userInfo?.toJson() ?? {};
    Map<String, dynamic> params = {
      ...userInfoParams,
      if (_nameController.text.isNotEmpty) 'name': _nameController.text,
      if (_phoneNumberController.text.isNotEmpty) 'phone': _phoneNumberController.text,
      if (_nicknameController.text.isNotEmpty) 'nickname': _nicknameController.text,
      if (_selectedGender.isNotEmpty) 'gender': _selectedGender,
      if (_birthdayController.text.isNotEmpty) 'birthday': _birthdayController.text,
      if (_emailController.text.isNotEmpty) 'email': _emailController.text,
    };
    await MyApi.saveUserInfoApi(params);
    _getUserInfo();
    // 保存成功提示
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('保存成功')),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool readOnly = false, Widget? suffixIcon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                label,
                style: const TextStyle(color: Colors.black, fontSize: 16),
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
                style: const TextStyle(color: Colors.black, fontSize: 16), // 添加字段值的样式
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Row(
          children: [
            const Expanded(
              flex: 1,
              child: Text('性别', style: TextStyle(fontSize: 16, color: Colors.black)),
            ),
            Expanded(
              flex: 7,
              child: Row(
                children: [
                  Radio<String>(
                    value: '男',
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                    activeColor: Colors.blue, // 修改选中颜色
                  ),
                  const Text('男'),
                  const SizedBox(width: 10),
                  Radio<String>(
                    value: '女',
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                    activeColor: Colors.blue, // 修改选中颜色
                  ),
                  const Text('女'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBirthdayPicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Row(
          children: [
            const Expanded(
              flex: 1,
              child: Text('生日', style: TextStyle(fontSize: 16, color: Colors.black)),
            ),
            Expanded(
              flex: 5,
              child: GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextField(
                    controller: _birthdayController,
                   decoration: const InputDecoration(
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.calendar_today_outlined, color: Colors.blue, size: 24), // 修改为设计稿中的图标
                    ),
                    style: const TextStyle(color: Colors.black, fontSize: 16), // 添加字段值的样式
                  ),
                ),
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
        title: const Text('基本信息'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            _buildTextField('姓名', _nameController),
            _buildTextField('手机', _phoneNumberController),
            _buildTextField('昵称', _nicknameController),
            _buildGenderSelection(),
            _buildBirthdayPicker(),
            _buildTextField('邮箱', _emailController),
            const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // 背景颜色
                foregroundColor: Colors.white, // 字体颜色
                padding: const EdgeInsets.symmetric(vertical: 15), // 内边距
                textStyle: const TextStyle(fontSize: 18), // 字体大小
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // 圆角
                ),
                elevation: 3, // 阴影
              ),
              child: const Text('保存'),
            ),
          ),
          ],
        ),
      ),
    );
  }
}