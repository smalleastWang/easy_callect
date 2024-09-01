import 'package:easy_collect/api/milksidentify.dart';
import 'package:flutter/material.dart';
import 'package:easy_collect/widgets/OrgTreeSelector/OrgTreeSelector.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class EditMilksidentifyPage extends StatefulWidget {
  final GoRouterState? state;
  const EditMilksidentifyPage({super.key, this.state});
  
  @override
  State<EditMilksidentifyPage> createState() => _EditMilksidentifyPageState();
}

class _EditMilksidentifyPageState extends State<EditMilksidentifyPage> {
  late GoRouterState state;
  late final Map<String, dynamic>? milksidentify;
  final TextEditingController _orgController = TextEditingController();
  final TextEditingController _algorithmCodeController = TextEditingController();
  final TextEditingController _milkPosController = TextEditingController();
  final TextEditingController _devIdController = TextEditingController();
  final TextEditingController _noController = TextEditingController();
  final GlobalKey<OrgTreeSelectorState> _orgTreeSelectorKey = GlobalKey<OrgTreeSelectorState>();

  String? orgId;
  DateTime? _identifyTime;

  @override
  void initState() {
    super.initState();
    milksidentify = widget.state?.extra as Map<String, dynamic>? ?? {};
    if (milksidentify != null) {
      setState(() {
        orgId = milksidentify!['orgId'] ?? '';
        _orgController.text = milksidentify!['orgName'] ?? '';
        _milkPosController.text = milksidentify!['milkPos'] ?? '';
        _algorithmCodeController.text = milksidentify!['algorithmCode'] ?? '';
        _devIdController.text = milksidentify!['devId'] ?? '';
        _noController.text = milksidentify!['no'] ?? '';
        if (milksidentify!['identifyTime'] != null) {
          _identifyTime = DateTime.parse(milksidentify!['identifyTime']);
        }
      });
    }
  }

  @override
  void dispose() {
    _orgController.dispose();
    _algorithmCodeController.dispose();
    _milkPosController.dispose();
    _devIdController.dispose();
    _noController.dispose();
    super.dispose();
  }

  void _saveMilksidentify() async {
    // 检查必填字段是否为空
    if (_orgController.text.isEmpty ||
        _algorithmCodeController.text.isEmpty ||
        _milkPosController.text.isEmpty ||
        _devIdController.text.isEmpty ||
        _noController.text.isEmpty ||
        _identifyTime == null) {
      String missingFields = '';
      if (_orgController.text.isEmpty) missingFields += '牧场, ';
      if (_algorithmCodeController.text.isEmpty) missingFields += '唯一码, ';
      if (_milkPosController.text.isEmpty) missingFields += '挤奶位编号, ';
      if (_devIdController.text.isEmpty) missingFields += '设备唯一码, ';
      if (_noController.text.isEmpty) missingFields += '耳标号, ';
      if (_identifyTime == null) missingFields += '上传时间, ';
      missingFields = missingFields.substring(0, missingFields.length - 2); // 去掉最后一个逗号和空格

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('请填写以下必填字段: $missingFields')),
      );
      return;
    }

    // 格式化日期时间
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    String identifyTimeStr = formatter.format(_identifyTime!);

    // 构建保存数据
    Map<String, dynamic> params = {
      'orgId': orgId,
      'algorithmCode': _algorithmCodeController.text,
      'name': _milkPosController.text,
      'devId': _devIdController.text,
      'no': _noController.text,
      'identifyTime': identifyTimeStr,
    };

    if (milksidentify?["id"] != null && milksidentify!["id"].isNotEmpty) {
      params["id"] = milksidentify?["id"];
    }

    // 保存数据到API
    await addMilksidentify(params);

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
    _algorithmCodeController.clear();
    _milkPosController.clear();
    _devIdController.clear();
    _noController.clear();
    orgId = null;
    _identifyTime = null;
  }

  void _selectOrg() {
    _orgTreeSelectorKey.currentState?.show();
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
              flex: 0,
              child: Row(
                children: [
                  const Text(
                    '*',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // const SizedBox(width: 4),
            Expanded(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (milksidentify?["id"] != null && milksidentify!["id"].isNotEmpty) 
        ? const Text('编辑在位识别信息') 
        : const Text('添加在位识别信息'),
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
              '牧场：',
              _orgController,
              isRequired: true,
              suffixIcon: const Icon(Icons.arrow_forward_ios, size: 16),
              readOnly: true,
              onTap: _selectOrg,
            ),
            _buildTextField(
              '唯一码：',
              _algorithmCodeController,
              isRequired: true,
            ),
            _buildTextField(
              '挤奶位编号：',
              _milkPosController,
              isRequired: true,
            ),
            _buildTextField(
              '设备唯一码：',
              _devIdController,
              isRequired: true,
            ),
            _buildTextField(
              '耳标号：',
              _noController,
              isRequired: true,
            ),
            _buildDateTimeField(
              '上传时间：',
              _identifyTime,
              () => _selectDateTime(context, (DateTime dateTime) {
                setState(() {
                  _identifyTime = dateTime;
                });
              }),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveMilksidentify,
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