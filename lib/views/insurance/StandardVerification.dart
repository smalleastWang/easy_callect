
import 'package:easy_collect/api/insurance.dart';
import 'package:easy_collect/api/pigRegister.dart';
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/enums/index.dart';
import 'package:easy_collect/enums/register.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/widgets/Button/BlockButton.dart';
import 'package:easy_collect/widgets/Form/PickerFormField.dart';
import 'package:easy_collect/widgets/Form/PickerImageField.dart';
import 'package:easy_collect/widgets/List/PickerPastureWidget.dart';
import 'package:easy_collect/widgets/Register/RegisterType.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

///
/// 验标注册
class StandardVerificationPage extends ConsumerStatefulWidget {
  final RegisterAnimalType registerType;
  const StandardVerificationPage({super.key, required this.registerType});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StandardVerificationPageState();
}

class _StandardVerificationPageState extends ConsumerState<StandardVerificationPage> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  final TextEditingController _numController = TextEditingController();
  final PickerEditingController _enclosureController = PickerEditingController();
  PickerImageController _faceImgsController = PickerImageController();
  PickerImageController _bodyImgsController = PickerImageController();
  PickerImageController _dronesController = PickerImageController();

  bool submitLoading = false;
  int registerType = RegisterTypeEnum.single.value;
  int registerMedia = RegisterMediaEnum.face.value;

  @override
  void initState() {
    super.initState();
  }
  _changeRegisterType(value) {
    setState(() {
      registerType = value;
      _faceImgsController = PickerImageController();
      _bodyImgsController = PickerImageController();
      _dronesController = PickerImageController();
    });
  }
  Widget get _getRegisterCnt {
    onChange(value) {
      setState(() {
        registerMedia = value;
        _faceImgsController = PickerImageController();
        _bodyImgsController = PickerImageController();
        _dronesController = PickerImageController();
      });
    }
    if (registerType == RegisterTypeEnum.single.value) {
      return RegisterTypeWidget<int>(
        label: '注册方式',
        options: RegisterMediaEnum.getOptions(RegisterTypeEnum.single),
        onChange: onChange,
        defaultValue: RegisterMediaEnum.face.value
      );
    } else if (registerType == RegisterTypeEnum.multiple.value) {
      return RegisterTypeWidget<int>(
        label: '注册方式',
        options: RegisterMediaEnum.getOptions(RegisterTypeEnum.multiple),
        onChange: onChange,
        defaultValue: RegisterMediaEnum.drones.value
      );
    }
    return const SizedBox.shrink();
  }

  EnclosureModel? findNode(List<EnclosureModel> options) {
    for (var node in options) {
      if (node.id == _enclosureController.value!.last) {
        return node;
      }
      if (node.children != null) {
        return findNode(node.children!);
      }
    }
    return null;
  }

  _handleSubmit(List<EnclosureModel> options) async {
    if (_numController.text.isEmpty) return EasyLoading.showError('请选择输入牛编号');
    if (_enclosureController.value == null) return EasyLoading.showError('请选择牧场和圈舍');
    EnclosureModel? houseData = findNode(options);
    if (houseData == null || houseData.nodeType != 'bld') {
      return EasyLoading.showError('圈舍选择错误');
    }

    try {
      setState(() {
        submitLoading = true;
      });

      String isRegister  = await RegisterApi.isRegister({
        "cattleNo": _numController.text,
        "pastureId": houseData.parentId,
      });
      if (isRegister.toLowerCase() != 'false') {
        return EasyLoading.showError('编号在该牧场已注册');
      }

      RegisterQueryModel params = RegisterQueryModel(
        cattleNo: _numController.text,
        houseId: houseData.id,
        pastureId: houseData.parentId,
        // faceImgs: _imageController.value!.map((e) => e.value).toList()
      );
      
      // 无人机注册
      if (registerMedia == RegisterMediaEnum.drones.value) {
        if (_dronesController.value == null || _dronesController.value!.isEmpty) return EasyLoading.showError('请上传牛脸图片');
        params.faceImgs = _dronesController.value!.map((e) => e.value).toList();
        await RegisterApi.uavForm(UavRegisterQueryModel(
          batch: 0,
          houseId: houseData.id,
          pastureId: houseData.parentId,
          resourceType: ResourceTypeEnum.register.value,
          single: registerType,
          imgs: _dronesController.value!.map((e) => e.value).toList()
        ));
        context.pop();
        return;
      }
      // 单个注册
      if (registerMedia == RegisterMediaEnum.face.value) {
        if (_faceImgsController.value == null || _faceImgsController.value!.isEmpty) return EasyLoading.showError('请上传牛脸图片');
        params.faceImgs = _faceImgsController.value!.map((e) => e.value).toList();
      } else if (registerMedia == RegisterMediaEnum.back.value) {
        if (_bodyImgsController.value == null || _bodyImgsController.value!.isEmpty) return EasyLoading.showError('请上传牛脸图片');
        params.bodyImgs = _bodyImgsController.value!.map((e) => e.value).toList();
      }
      // 猪注册
      if (widget.registerType == RegisterAnimalType.pig) {
        params.pigNo = _numController.text;
        await registerPigAppApi(params);
      } else {
        await RegisterApi.cattleApp(params);
      }
      context.pop();
    } finally {
      setState(() {
        submitLoading = false;
      });
    }
    
  }

  List<Widget> get _getImgWidget {
    // 单个注册-牛脸注册
    if (registerType == RegisterTypeEnum.single.value && registerMedia == RegisterMediaEnum.face.value) {
      return [PickerImageField(controller: _faceImgsController, maxNum: 1, label: '牛脸图片')];
    }
    // 单个注册-牛背注册
    if (registerType == RegisterTypeEnum.single.value && registerMedia == RegisterMediaEnum.back.value) {
      return [
        PickerImageField(controller: _bodyImgsController, maxNum: 1, label: '牛背图片'),
        PickerImageField(controller: _faceImgsController, maxNum: 1, label: '牛脸图片'),
      ];
    }
    // 批量注册-无人机
    if (registerMedia == RegisterMediaEnum.drones.value) {
      return [PickerImageField(controller: _dronesController, maxNum: registerType == RegisterTypeEnum.single.value ? 1 : 9,label: '航拍图', uploadApi: RegisterApi.uavUpload)];
    }
    return [const SizedBox.shrink()];
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<EnclosureModel>> enclosureList = ref.watch(enclosureListProvider);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text(RouteEnum.standardVerification.title)),
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
                          validator: (v) {
                            return v!.trim().isNotEmpty ? null : "耳标号不能为空";
                          },
                        )
                      )
                      
                    ],
                  ),
                ),
                const SizedBox(height: 10),
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
                          isShed: true,
                          controller: _enclosureController,
                          options: enclosureList.value ?? [],
                        ),
                      )
                      
                    ],
                  ),
                ),
                RegisterTypeWidget<int>(defaultValue: registerType, options: enumsToOptions(RegisterTypeEnum.values), onChange: _changeRegisterType),
                _getRegisterCnt,
                
                ..._getImgWidget,

                const SizedBox(height: 50),
                BlockButton(
                  onPressed: submitLoading ? null : () => _handleSubmit(enclosureList.value ?? []),
                  text: '注册',
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}