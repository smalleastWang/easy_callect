
import 'package:easy_collect/api/insurance.dart';
import 'package:easy_collect/api/pigRegister.dart';
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/models/register/PigRegister.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/utils/camera/Config.dart';
import 'package:easy_collect/utils/regExp.dart';
import 'package:easy_collect/widgets/Button/BlockButton.dart';
import 'package:easy_collect/widgets/Form/PickerFormField.dart';
import 'package:easy_collect/widgets/Form/PickerImageField.dart';
import 'package:easy_collect/widgets/List/PickerPastureWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

///
/// 验标注册
class StandardVerificationPigPage extends ConsumerStatefulWidget {
  const StandardVerificationPigPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StandardVerificationPigPageState();
}

class _StandardVerificationPigPageState extends ConsumerState<StandardVerificationPigPage> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  final TextEditingController _numController = TextEditingController();
  final PickerEditingController _enclosureController = PickerEditingController();
  final PickerImageController _bodyImgsController = PickerImageController();

  bool submitLoading = false;

  @override
  void initState() {
    super.initState();
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

      String isRegister  = await RegisterApi.isRegister({
        "cattleNo": _numController.text,
        "pastureId": houseData.parentId,
      });
      if (isRegister.toLowerCase() != 'false') {
        return EasyLoading.showError('编号在该牧场已注册');
      }

      PigRegisterParams params = PigRegisterParams(
        pigNo: _numController.text,
        houseId: houseData.id,
        pastureId: houseData.parentId,
      );

      // 猪背注册
      if (_bodyImgsController.value == null || _bodyImgsController.value!.isEmpty) return EasyLoading.showError('请上传猪脸图片');
      if (_bodyImgsController.value!.length < 4) return EasyLoading.showError('请上传4张以上的猪背图片');
      params.bodyImgs = _bodyImgsController.value!.map((e) => e.value).toList();
      await registerPigAppApi(params);
      context.pop();
    } finally {
      setState(() {
        submitLoading = false;
      });
    }
    
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<EnclosureModel>> enclosureList = ref.watch(enclosureListProvider);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text(RouteEnum.standardVerificationPig.title)),
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
                // _getRegisterCnt,
                PickerImageField(controller: _bodyImgsController, maxNum: 20, label: '猪背图片', mTaskMode: EnumTaskMode.pigBodyRegister),
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