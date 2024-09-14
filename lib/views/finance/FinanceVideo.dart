
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
import 'package:easy_collect/widgets/List/PickerPastureWidget.dart';
import 'package:easy_collect/widgets/Register/EnclosurePicker.dart';
import 'package:easy_collect/widgets/Register/RegisterType.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

///
/// 查勘对比
class FinanceVideoPage extends ConsumerStatefulWidget {
  const FinanceVideoPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FinanceVideoPageState();
}

class _FinanceVideoPageState extends ConsumerState<FinanceVideoPage> {
  
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
    final AsyncValue<List<EnclosureModel>> enclosureList = ref.watch(enclosureListProvider);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text(RouteEnum.financeVideo.title)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFE9E8E8))
                    )
                  ),
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 80,
                        child: Text('耳标号', style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500)),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _numController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '请输入牛耳耳标号(不支持中文)'
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')), // 仅允许数字和英文字母
                          ],
                          validator: (v) {
                            return RegExpValidator.numberAndLetter(v, '耳标号');
                          },
                        )
                      )
                      
                    ],
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFE9E8E8))
                    )
                  ),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 80,
                        child: Text('牧场/圈舍', style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500)),
                      ),
                      Expanded(
                        child: PickerPastureWidget(
                          selectLast: SelectLast.shed,
                          controller: _enclosureController,
                          options: enclosureList.value ?? [],
                        ),
                      )
                    ],
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