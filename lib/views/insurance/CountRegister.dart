
import 'package:easy_collect/api/insurance.dart';
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/enums/index.dart';
import 'package:easy_collect/enums/register.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/utils/camera/Config.dart';
import 'package:easy_collect/utils/regExp.dart';
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
/// 计数盘点
class CountRegisterPage extends ConsumerStatefulWidget {
  const CountRegisterPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CountRegisterPageState();
}

class _CountRegisterPageState extends ConsumerState<CountRegisterPage> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  final TextEditingController _numController = TextEditingController();
  final PickerEditingController _enclosureController = PickerEditingController();
  PickerImageController _imgsController = PickerImageController();
  PickerImageController _videoController = PickerImageController();

  GlobalKey<PickerImageFieldState> imgsWidgetState = GlobalKey<PickerImageFieldState>();
  GlobalKey<PickerImageFieldState> videoWidgetState = GlobalKey<PickerImageFieldState>();

  bool submitLoading = false;
  String countMedia = CountMediaEnum.img.value;

  @override
  void initState() {
    super.initState();
  }
  _changeRegisterMedia(value) {
    imgsWidgetState.currentState?.clearPickImages();
    videoWidgetState.currentState?.clearPickImages();
    setState(() {
      countMedia = value;
      _imgsController = PickerImageController();
      _videoController = PickerImageController();
    });
  }

  List<Widget> get _getImgWidget {
    // 单个注册-牛脸注册
    if (countMedia == CountMediaEnum.img.value) {
      return [
        PickerImageField(key: imgsWidgetState, controller: _imgsController, maxNum: 20, label: '图片', mTaskMode: EnumTaskMode.countImgsInventory),
      ];
    } else if (countMedia == CountMediaEnum.video.value) {
      return [
        PickerImageField(key: videoWidgetState, controller: _videoController, maxNum: 20, label: '视频', mTaskMode: EnumTaskMode.countVideoInventory),
      ];
    }
    
    return [const SizedBox.shrink()];
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

      Map<String, dynamic> params = {
        'model': countMedia
      };
      // 图片盘点
      if (countMedia == CountMediaEnum.img.value) {
        if (_imgsController.value == null || _imgsController.value!.isEmpty) return EasyLoading.showError('请上传图片');
        params['input'] = _imgsController.value!.map((e) => e.value).first;
        await RegisterApi.countInventory(params);
        context.pop();
        return;
      }
      
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
      appBar: AppBar(title: Text(RouteEnum.countRegister.title)),
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
                            return RegExpValidator.numner(v, '耳标号');
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
                RegisterTypeWidget<String>(defaultValue: countMedia, options: enumsStrValToOptions(CountMediaEnum.values), onChange: _changeRegisterMedia),


                ..._getImgWidget,
                
                PickerImageField(controller: _imgsController, maxNum: 1, label: CountMediaEnum.getLabel(countMedia), uploadApi: RegisterApi.scanAmountUpload),

                const SizedBox(height: 50),
                BlockButton(
                  onPressed: submitLoading ? null : () => _handleSubmit(enclosureList.value ?? []),
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