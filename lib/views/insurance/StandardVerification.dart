import 'dart:convert';
import 'package:easy_collect/api/register.dart';
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/utils/tool/common.dart';
import 'package:easy_collect/views/insurance/data.dart';
import 'package:easy_collect/widgets/Form/PickerFormField.dart';
import 'package:easy_collect/widgets/Form/PickerImageField.dart';
import 'package:easy_collect/widgets/Register/EnclosurePicker.dart';
import 'package:easy_collect/widgets/Register/RegisterType.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';


final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class StandardVerificationPage extends StatefulWidget {
  const StandardVerificationPage({super.key});

  @override
  State<StandardVerificationPage> createState() => _StandardVerificationPageState();
}

class _StandardVerificationPageState extends State<StandardVerificationPage> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey _formKey = GlobalKey<FormState>();
  final TextEditingController _numController = TextEditingController();
  final PickerEditingController _enclosureController = PickerEditingController();
  final PickerImageController _imageController = PickerImageController();

  int registerType = 1;
  int changeRegisterCnt = 1;

  @override
  void initState() {
    super.initState();
  }
  _changeRegisterType(value) {
    setState(() {
      registerType = value;
    });
  }

  _changeRegisterCnt(value) {
    setState(() {
      changeRegisterCnt = value;
    });
  }
  Widget get _getRegisterCnt {
    if (registerType == 1) {
      return RegisterTypeWidget<int>(options: singleOptions, onChange: _changeRegisterCnt, label: '注册方式');
    } else if (registerType == 2) {
      return RegisterTypeWidget<int>(options: multipleOptions, onChange: _changeRegisterCnt, label: '注册方式');
    }
    return const SizedBox.shrink();
  }

  _handleSubmit() async {
    if (_numController.text.isEmpty) return EasyLoading.showError('请选择输入牛编号');
    if (_enclosureController.value == null) return EasyLoading.showError('请选择牧场和圈舍');
    if (_imageController.value == null) return EasyLoading.showError('请选择图片');

    RegisterQueryModel params = RegisterQueryModel(
      cattleNo: _numController.text,
      pastureId: _enclosureController.value!.last,
      houseId: _enclosureController.value![_enclosureController.value!.length -2],
      faceImgs: _imageController.value!.map((e) => e.value).toList()
    );
    await RegisterApi.cattleApp(params);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(title: Text(RouteEnum.standardVerification.title)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _numController,
                  decoration: getInputDecoration(
                    labelText: '耳标号',
                    hintText: '请输入牛耳耳标号(不支持中文)',
                  ),
                  validator: (v) {
                    return v!.trim().isNotEmpty ? null : "耳标号不能为空";
                  },
                ),
                const SizedBox(height: 16),
                EnclosurePickerWidget(
                  controller: _enclosureController,
                  decoration: getInputDecoration(
                    labelText: '牧场/圈舍',
                    hintText: '请输入牛耳耳标号(不支持中文)',
                  ),
                ),
                RegisterTypeWidget<int>(defaultValue: registerType, options: registerTypeOptions, onChange: _changeRegisterType),
                _getRegisterCnt,
                PickerImageField(controller: _imageController, maxNum: 1),

                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: _handleSubmit,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: const Text('注册', style: TextStyle(fontSize: 16))
                  ),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}