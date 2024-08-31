
import 'package:easy_collect/api/insurance.dart';
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/enums/index.dart';
import 'package:easy_collect/enums/register.dart';
import 'package:easy_collect/mock.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/utils/regExp.dart';
import 'package:easy_collect/utils/tool/common.dart';
import 'package:easy_collect/widgets/Button/BlockButton.dart';
import 'package:easy_collect/widgets/Form/PickerFormField.dart';
import 'package:easy_collect/widgets/Form/PickerImageField.dart';
import 'package:easy_collect/widgets/Register/EnclosurePicker.dart';
import 'package:easy_collect/widgets/Register/RegisterType.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';


final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

///
/// 查勘对比
class FinanceCountPage extends StatefulWidget {
  const FinanceCountPage({super.key});

  @override
  State<FinanceCountPage> createState() => _FinanceCountPageState();
}

class _FinanceCountPageState extends State<FinanceCountPage> {
  
  final GlobalKey _formKey = GlobalKey<FormState>();
  final TextEditingController _numController = TextEditingController();
  final PickerEditingController _enclosureController = PickerEditingController();
  PickerImageController _imageController = PickerImageController();

  int registerType = 1;
  int changeRegisterCnt = 1;

  @override
  void initState() {
    super.initState();
  }
  _changeRegisterType(value) {
    setState(() {
      registerType = value;
      _imageController = PickerImageController();
    });
  }

  _changeRegisterCnt(value) {
    setState(() {
      changeRegisterCnt = value;
      _imageController = PickerImageController();
    });
  }
  Widget get _getRegisterCnt {
    if (registerType == 1) {
      return RegisterTypeWidget<int>(options: enumsToOptions(RegisterFaceEnum.values), onChange: _changeRegisterCnt, label: '注册方式', defaultValue: RegisterFaceEnum.face.value);
    } else if (registerType == 2) {
      return RegisterTypeWidget<int>(options: enumsToOptions(RegisterMediaEnum.values), onChange: _changeRegisterCnt, label: '注册方式', defaultValue: RegisterMediaEnum.drones.value);
    }
    return const SizedBox.shrink();
  }

  _handleSubmit() async {
    if (_numController.text.isEmpty) return EasyLoading.showError('请选择输入牛编号');
    if (_enclosureController.value == null) return EasyLoading.showError('请选择牧场和圈舍');
    if (_imageController.value == null) return EasyLoading.showError('请选择图片');

    RegisterQueryModel params = RegisterQueryModel(
      cattleNo: _numController.text,
      houseId: _enclosureController.value!.last,
      pastureId: _enclosureController.value![_enclosureController.value!.length -2],
      faceImgs: _imageController.value!.map((e) => e.value).toList()
    );
    // 单个注册
    if (registerType == 1) {
      if (changeRegisterCnt == 1) {
        // params.faceImgs = _imageController.value!.map((e) => e.value).toList();
        // <List<String>> faceImgs = [];
        // faceImgs.add(imagesStr['face_image'])
        params.faceImgs = imagesStr['face_image'].cast<List<String>>();
      } else if (registerType == 2) {
        params.bodyImgs = _imageController.value!.map((e) => e.value).toList();
      }
    }
    await RegisterApi.cattleApp(params);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text(RouteEnum.financeCount.title)),
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
                    return RegExpValidator.numner(v, '耳标号');
                  },
                ),
                const SizedBox(height: 16),
                EnclosurePickerWidget(
                  scaffoldKey: _scaffoldKey,
                  controller: _enclosureController,
                  decoration: getInputDecoration(
                    labelText: '牧场/圈舍',
                    hintText: '请输入牛耳耳标号(不支持中文)',
                  ),
                ),
                RegisterTypeWidget<int>(defaultValue: registerType, options: enumsToOptions(RegisterTypeEnum.values), onChange: _changeRegisterType),
                _getRegisterCnt,
                PickerImageField(controller: _imageController, maxNum: 1),

                const SizedBox(height: 50),
                BlockButton(
                  onPressed: _handleSubmit,
                  text: '注册'
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}