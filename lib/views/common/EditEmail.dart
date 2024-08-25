import 'package:flutter/material.dart';
import 'package:easy_collect/api/email.dart';
import 'package:easy_collect/widgets/OrgTreeSelector/OrgTreeSelector.dart';
import 'package:go_router/go_router.dart';

class EditEmailPage extends StatefulWidget {
  final GoRouterState? state;
  const EditEmailPage({super.key, this.state});
  
  @override
  State<EditEmailPage> createState() => _EditEmailPageState();
}

class _EditEmailPageState extends State<EditEmailPage> {
  late GoRouterState state;
  late final Map<String, dynamic>? email;
  final TextEditingController _orgController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailInputController = TextEditingController();
  final GlobalKey<OrgTreeSelectorState> _orgTreeSelectorKey = GlobalKey<OrgTreeSelectorState>();

  String? orgId;
  List<String> _emailList = [];

  @override
  void initState() {
    super.initState();
    email = widget.state?.extra as Map<String, dynamic>? ?? {};
    if (widget.state != null && widget.state!.extra != null) {
      setState(() {
        orgId = email!['orgId'] ?? '';
        _orgController.text = email!['orgName'] ?? '';
        _nameController.text = email!['name'] ?? '';
        _emailList = email!['emails'].split('、') ?? [];
      });
    }
  }

  @override
  void dispose() {
    _orgController.dispose();
    _nameController.dispose();
    _emailInputController.dispose();
    super.dispose();
  }

  void _saveBuilding() async {
    // 检查必填字段是否为空
    if (_orgController.text.isEmpty || _nameController.text.isEmpty || _emailList.isEmpty) {
      String missingFields = '';
      if (_orgController.text.isEmpty) missingFields += '组织, ';
      if (_nameController.text.isEmpty) missingFields += '姓名, ';
      missingFields = missingFields.substring(0, missingFields.length - 2); // 去掉最后一个逗号和空格

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('请填写以下必填字段: $missingFields')),
      );
      return;
    }

    // 构建保存数据
    Map<String, dynamic> params = {
      'orgId': orgId,
      'name': _nameController.text,
      'emails': _emailList.join(','),
    };

    if(email?["id"] != null && email!["id"].isNotEmpty) {
      params["id"] = email?["id"];
    }

    // 保存数据到API
    await addEmail(params);

    // 保存成功提示
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('保存成功')),
    );

    // 等待1秒再刷新列表
    await Future.delayed(const Duration(seconds: 1));

    Navigator.of(context).pop(true);

    // 清空表单
    _clearForm();
  }

  void _clearForm() {
    _orgController.clear();
    _nameController.clear();
    _emailInputController.clear();
    _emailList.clear();
    orgId = null;
  }

  void _selectOrg() {
    _orgTreeSelectorKey.currentState?.show();
  }

  void _addEmail() {
    final email = _emailInputController.text.trim();

    // 邮箱格式验证
    final RegExp emailRegExp = RegExp(
      r'^[^@]+@[^@]+\.[^@]+',
    );

    if (email.isNotEmpty && !_emailList.contains(email)) {
      if (emailRegExp.hasMatch(email)) {
        setState(() {
          _emailList.add(email);
          _emailInputController.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('请输入有效的邮箱地址')),
        );
      }
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
                IntrinsicWidth(
                  child: Row(
                    children: [
                      if (isRequired)
                        const Text(
                          '*',
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      if (isRequired)
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

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField('   邮箱：', _emailInputController, suffixIcon: IconButton(
          icon: const Icon(Icons.add),
          onPressed: _addEmail,
        )),
        Wrap(
          spacing: 8.0,
          children: _emailList.map((email) {
            return Chip(
              label: Text(email),
              onDeleted: () {
                setState(() {
                  _emailList.remove(email);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (email?["id"] != null && email!["id"].isNotEmpty) 
        ? const Text('编辑邮箱') 
        : const Text('添加邮箱'),
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
            _buildTextField('姓名：', _nameController, isRequired: true),
            _buildTextField(
              '牧场：',
              _orgController,
              isRequired: true,
              suffixIcon: const Icon(Icons.arrow_forward_ios, size: 16),
              readOnly: true,
              onTap: _selectOrg,
            ),
            _buildEmailField(),
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
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}