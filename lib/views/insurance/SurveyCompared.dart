
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
/// 查勘对比
class SurveyComparedPage extends ConsumerStatefulWidget {
  const SurveyComparedPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SurveyComparedPageState();
}

class _SurveyComparedPageState extends ConsumerState<SurveyComparedPage> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  final TextEditingController _numController = TextEditingController();
  final PickerEditingController _enclosureController = PickerEditingController();

  PickerImageController _dronesController = PickerImageController();
  PickerImageController _videoController = PickerImageController();

  GlobalKey<PickerImageFieldState> dronesWidgetState = GlobalKey<PickerImageFieldState>();
  GlobalKey<PickerImageFieldState> videoWidgetState = GlobalKey<PickerImageFieldState>();

  bool submitLoading = false;
  int registerMedia = RegisterMediaEnum.drones.value;

  @override
  void initState() {
    super.initState();
  }
  Widget get _getRegisterCnt {
    onChange(value) {
      dronesWidgetState.currentState?.clearPickImages();
      videoWidgetState.currentState?.clearPickImages();
      setState(() {
        registerMedia = value;
        _dronesController = PickerImageController();
        _videoController = PickerImageController();
      });
    }
    return RegisterTypeWidget<int>(
      label: '注册方式',
      options: enumsToOptions(SurveyMediaEnum.values),
      onChange: onChange,
      defaultValue: SurveyMediaEnum.drones.value
    );
  }

  List<Widget> get _getImgWidget {
    // 批量注册-无人机
    if (registerMedia == SurveyMediaEnum.drones.value) {
      return [PickerImageField(key: dronesWidgetState, controller: _dronesController, maxNum: 20, label: '航拍图', uploadApi: RegisterApi.uavUpload, registerMedia: registerMedia, mTaskMode: EnumTaskMode.cowDronesIdentify)];
    } else if (registerMedia == SurveyMediaEnum.video.value) {
      return [PickerImageField(key: videoWidgetState, controller: _videoController, maxNum: 20, label: '视频', registerMedia: registerMedia, mTaskMode: EnumTaskMode.cowVideoIdentify)];
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

      RegisterQueryModel params = RegisterQueryModel(
        cattleNo: _numController.text,
        houseId: houseData.id,
        pastureId: houseData.parentId,
      );
      // 无人机查勘
      if (registerMedia == RegisterMediaEnum.drones.value) {
        if (_dronesController.value == null || _dronesController.value!.isEmpty) return EasyLoading.showError('请上传牛脸图片');
        params.faceImgs = _dronesController.value!.map((e) => e.value).toList();
        await RegisterApi.uavForm(UavRegisterQueryModel(
          batch: 0,
          houseId: houseData.id,
          pastureId: houseData.parentId,
          resourceType: ResourceTypeEnum.discern.value,
          single: RegisterTypeEnum.multiple.value,
          imgs: _dronesController.value!.map((e) => e.value).toList()
        ));
        context.pop();
        return;
      // 视频
      } else if (registerMedia == RegisterMediaEnum.video.value) {
        RegisterApi.videoSurvey(UavRegisterQueryModel(
          batch: 0,
          houseId: houseData.id,
          pastureId: houseData.parentId,
          resourceType: ResourceTypeEnum.discern.value,
          single: RegisterTypeEnum.multiple.value,
          imgs: _videoController.value!.map((e) => e.value).toList(),
          urlType: 2
        ));
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
      appBar: AppBar(title: Text(RouteEnum.surveyCompared.title)),
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