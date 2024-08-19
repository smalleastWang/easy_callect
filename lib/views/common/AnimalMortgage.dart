import 'package:easy_collect/api/animal.dart';
import 'package:flutter/material.dart';
import 'package:easy_collect/widgets/BankSelector/BankSelector.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // 引入 BankSelector

class AnimalMortgagePage extends StatefulWidget {
  final GoRouterState? state;
  const AnimalMortgagePage({super.key, this.state});

  @override
  State<AnimalMortgagePage> createState() => _AnimalMortgagePageState();
}

class _AnimalMortgagePageState extends State<AnimalMortgagePage> {
  late GoRouterState state;
  late final Map<String, dynamic> animal;
  final TextEditingController _bankController = TextEditingController();
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  final TextEditingController _creditController = TextEditingController();
  final TextEditingController _borrowController = TextEditingController();
  final GlobalKey<BankSelectorState> _bankSelectorKey = GlobalKey<BankSelectorState>();

  String? bankId; // 用于保存选择的bankId
  DateTime? _mortgageStartTime;
  DateTime? _mortgageEndTime;

   @override
  void initState() {
    super.initState();
    if (widget.state != null && widget.state!.extra != null) {
      animal = widget.state!.extra as Map<String, dynamic>;
    }
  }

  @override
  void dispose() {
    _bankController.dispose();
    _startController.dispose();
    _endController.dispose();
    _creditController.dispose();
    _borrowController.dispose();
    super.dispose();
  }

  void _saveData() async {
    if (_bankController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请填写银行')),
      );
      return;
    }
    
    if (_startController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请填写抵押开始时间')),
      );
      return;
    }
    
    if (_endController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请填写抵押结束时间')),
      );
      return;
    }
    
    if (_creditController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请填写信用额度')),
      );
      return;
    }
    
    if (_borrowController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请填写借款金额')),
      );
      return;
    }

    // 格式化日期时间
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    String startTimeStr = formatter.format(DateTime.parse(_startController.text));
    String endTimeStr = formatter.format(DateTime.parse(_endController.text));

    // 构建保存数据
    Map<String, dynamic> params = {
      'cattleIds': animal['id'], // 若多个逗号隔开
      'bankId': bankId,
      'start': startTimeStr,
      'end': endTimeStr,
      'credit': _creditController.text,
      'borrow': _borrowController.text,
    };

    // 保存数据到API
    await animalMortgage(params);

    // 保存成功提示
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('抵押成功')),
    );

    Navigator.of(context).pop(true);

    // 清空表单
    _clearForm();
  }

  void _clearForm() {
    _bankController.clear();
    _startController.clear();
    _endController.clear();
    _creditController.clear();
    _borrowController.clear();
    bankId = null;
  }

  void _selectBank() {
    _bankSelectorKey.currentState?.show();
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

  Widget _buildDateTimeField(String label, int? labelFlexNum, DateTime? dateTime, Function() onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: labelFlexNum ?? 2,
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
              flex: 5,
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

  Widget _buildTextField(String label, int? labelFlexNum, TextEditingController controller,
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
                  flex: labelFlexNum ?? 2,
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
        title: const Text('抵押'),
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
              '金融机构',
              3,
              _bankController,
              isRequired: true,
              suffixIcon: const Icon(Icons.arrow_forward_ios, size: 16,),
              readOnly: true,
              onTap: _selectBank,
            ),
            _buildDateTimeField('抵押开始时间', 3, _mortgageStartTime, () async {
              await _selectDateTime(context, (dateTime) {
                setState(() {
                  _mortgageStartTime = dateTime;
                  _startController.text = dateTime.toIso8601String();
                });
              });
            }),
            _buildDateTimeField('抵押结束时间', 3, _mortgageEndTime, () async {
              await _selectDateTime(context, (dateTime) {
                setState(() {
                  _mortgageEndTime = dateTime;
                  _endController.text = dateTime.toIso8601String();
                });
              });
            }),
            _buildTextField('授信额度（万元）', 4, _creditController, isRequired: true),
            _buildTextField('抵押放款（万元）', 4, _borrowController, isRequired: true),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveData,
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
                child: const Text('确定'),
              ),
            ),
            BankSelector(
              key: _bankSelectorKey,
              onBankSelected: (data) {
                setState(() {
                  bankId = data?.id;
                  _bankController.text = data?.name ?? '';
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}