
import 'package:easy_collect/api/insurance.dart';
import 'package:easy_collect/api/pigRegister.dart';
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/enums/index.dart';
import 'package:easy_collect/enums/register.dart';
import 'package:easy_collect/models/register/PigRegister.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/utils/dialog.dart';
import 'package:easy_collect/utils/regExp.dart';
import 'package:easy_collect/widgets/Button/BlockButton.dart';
import 'package:easy_collect/widgets/Form/PickerFormField.dart';
import 'package:easy_collect/widgets/Form/PickerImageField.dart';
import 'package:easy_collect/widgets/List/ListItem.dart';
import 'package:easy_collect/widgets/List/PickerPastureWidget.dart';
import 'package:easy_collect/widgets/Register/RegisterType.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

///
/// 查勘对比
class SurveyComparedPigPage extends ConsumerStatefulWidget {
  const SurveyComparedPigPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SurveyComparedPigPageState();
}

class _SurveyComparedPigPageState extends ConsumerState<SurveyComparedPigPage> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  final TextEditingController _numController = TextEditingController();
  final PickerEditingController _enclosureController = PickerEditingController();
  PickerImageController _faceImgsController = PickerImageController();
  PickerImageController _bodyImgsController = PickerImageController();

  bool submitLoading = false;
  int registerMedia = RegisterMediaEnum.face.value;

  @override
  void initState() {
    super.initState();
  }
  Widget get _getRegisterCnt {
    onChange(value) {
      setState(() {
        registerMedia = value;
        _faceImgsController = PickerImageController();
        _bodyImgsController = PickerImageController();
      });
    }
    return RegisterTypeWidget<int>(
      label: '查勘方式',
      options: enumsToOptions(PigSurveyMediaEnum.values),
      onChange: onChange,
      defaultValue: SurveyMediaEnum.drones.value
    );
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
    if (_numController.text.isEmpty) return EasyLoading.showError('请选择输入猪编号');
    if (_enclosureController.value == null) return EasyLoading.showError('请选择牧场和圈舍');
    EnclosureModel? houseData = findNode(options);
    if (houseData == null || houseData.nodeType != 'bld') {
      return EasyLoading.showError('圈舍选择错误');
    }

    try {
      setState(() {
        submitLoading = true;
      });

      DistinguishPigAppParams params = DistinguishPigAppParams(
        earId: _numController.text,
        pastureId: houseData.parentId,
        faceImgs: [],
      );
      Map<String, dynamic> detail = await distinguishPigAppApi(params);
      _showDetail([
        ListColumnModal(field: 'bankAuthEnd', label: '金融机构授权开始时间'),
        ListColumnModal(field: 'bankAuthEnd', label: '金融机构授权开始时间'),
        ListColumnModal(field: 'breed', label: '繁殖状态'),
        ListColumnModal(field: 'buildingName', label: '	圈舍名称'),
        ListColumnModal(field: 'growth', label: '生长周期'),
        ListColumnModal(field: 'insureNo', label: '保单号'),
        ListColumnModal(field: 'isNeedAuth', label: '是否需要授权'),
        ListColumnModal(field: 'mort', label: '抵押状态'),
        ListColumnModal(field: 'mortEnd', label: '抵押到期时间'),
        ListColumnModal(field: 'no', label: '编号'),
        ListColumnModal(field: 'orgName', label: '牧场名称'),
      ], detail);
    } finally {
      setState(() {
        submitLoading = false;
      });
    }
  }

  _showDetail(List<ListColumnModal> columns, Map<String, dynamic> data) {
    showMyModalBottomSheet(
      context: context,
      title: '详情信息',
      contentBuilder: (BuildContext context) {
        return Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: columns.map((e) => Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(e.label, style: const TextStyle(color: Color(0xFF666666))),
                    ),
                    Expanded(
                      child: e.render == null ? Text(data[e.field] ?? '-') : e.render!(data[e.field], data, e)
                    )
                    
                  ],
                ),
              )).toList()
            ),
          )
        );
      }
    );
  }

  

  List<Widget> get _getImgWidget {
    // 单个注册-猪脸注册
    if (registerMedia == RegisterMediaEnum.face.value) {
      return [PickerImageField(controller: _faceImgsController, maxNum: 1, label: '请上传猪脸图片', registerMedia: registerMedia)];
    }
    // 单个注册-猪背注册
    if (registerMedia == RegisterMediaEnum.back.value) {
      return [
        PickerImageField(controller: _bodyImgsController, maxNum: 1, label: '请上传猪背图片', registerMedia: registerMedia),
        PickerImageField(controller: _faceImgsController, maxNum: 1, label: '请上传猪脸图片', registerMedia: registerMedia),
      ];
    }
    return [const SizedBox.shrink()];
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<EnclosureModel>> enclosureList = ref.watch(enclosureListProvider);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text(RouteEnum.surveyComparedPig.title)),
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
                            hintText: '请输入猪耳耳标号(不支持中文)'
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
                          selectLast: SelectLast.shed,
                          controller: _enclosureController,
                          options: enclosureList.value ?? [],
                        ),
                      )
                      
                    ],
                  ),
                ),
                _getRegisterCnt,

                
                ..._getImgWidget,

                const SizedBox(height: 50),
                BlockButton(
                  onPressed: submitLoading ? null : () => _handleSubmit(enclosureList.value ?? []),
                  text: '查勘'
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}