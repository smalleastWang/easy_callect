
import 'package:easy_collect/api/insurance.dart';
import 'package:easy_collect/api/security.dart';
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/enums/StorageKey.dart';
import 'package:easy_collect/enums/index.dart';
import 'package:easy_collect/enums/register.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/utils/camera/Config.dart';
import 'package:easy_collect/widgets/Button/BlockButton.dart';
import 'package:easy_collect/widgets/Form/PickerFormField.dart';
import 'package:easy_collect/widgets/Form/PickerImageField.dart';
import 'package:easy_collect/widgets/List/PickerPastureWidget.dart';
import 'package:easy_collect/widgets/Register/RegisterType.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_picker/picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

///
/// 计数盘点
class CountRegisterPage extends ConsumerStatefulWidget {
  const CountRegisterPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CountRegisterPageState();
}

class _CountRegisterPageState extends ConsumerState<CountRegisterPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey _formKey = GlobalKey<FormState>();
  final PickerEditingController _enclosureController = PickerEditingController();
  PickerImageController _imgsController = PickerImageController();
  PickerImageController _videoController = PickerImageController();
  TextEditingController _streamStrController = TextEditingController();

  GlobalKey<PickerImageFieldState> imgsWidgetState = GlobalKey<PickerImageFieldState>();
  GlobalKey<PickerImageFieldState> videoWidgetState = GlobalKey<PickerImageFieldState>();

  bool submitLoading = false;
  String countMedia = CountRegisterMediaEnum.cattleImg.value;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }
  _changeRegisterMedia(value) {
    imgsWidgetState.currentState?.clearPickImages();
    videoWidgetState.currentState?.clearPickImages();
    setState(() {
      countMedia = value;
      _imgsController = PickerImageController();
      _videoController = PickerImageController();
      _streamStrController = TextEditingController();
    });
  }

  Widget get _getImgWidget {
    final countMediaEnum = CountRegisterMediaEnum.values.singleWhere((e) => e.value == countMedia);
    switch(countMediaEnum) {
      case CountRegisterMediaEnum.cattleImg: return PickerImageField(
        key: imgsWidgetState,
        controller: _imgsController,
        maxNum: 1,
        label: '图片',
        registerMedia: RegisterMediaEnum.face.value,
        uploadApi: RegisterApi.scanAmountUpload,
        mTaskMode: EnumTaskMode.cowFaceRegister
      );
      case CountRegisterMediaEnum.cattleVideo:
      case CountRegisterMediaEnum.pigVideo: return PickerImageField(
        key: videoWidgetState,
        controller: _videoController,
        maxNum: 1,
        label: '视频',
        registerMedia: RegisterMediaEnum.video.value,
        uploadApi: RegisterApi.scanAmountUpload,
        mTaskMode: countMediaEnum == CountRegisterMediaEnum.cattleVideo ? EnumTaskMode.cowFaceIdentify : EnumTaskMode.pigBodyIdentify
      );
      case CountRegisterMediaEnum.cattleStream:
      case CountRegisterMediaEnum.pigStream: return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 10), 
            child: Text('视频流地址'),
          ),
          TextFormField(
            controller: _streamStrController,
            decoration: const InputDecoration(
              // border: InputBorder.none,
              hintText: '请输入视频流地址'
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return '视频流地址不能为空';
              return null;
            },
          )
        ]
      );
      default: return const SizedBox.shrink();
    }
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
    if (_enclosureController.value == null) return EasyLoading.showError('请选择牧场');

    try {
      setState(() {
        submitLoading = true;
      });

      Map<String, dynamic> params = {
        'model': countMedia,
        'orgId': _enclosureController.value!.last
      };
      if (CountRegisterMediaEnum.cattleImg.value == countMedia) {
        if (_imgsController.value == null || _imgsController.value!.isEmpty) return EasyLoading.showError('请上传图片');
        params['input'] = _imgsController.value!.map((e) => e.value).first;
      }
      if ([CountRegisterMediaEnum.cattleVideo.value, CountRegisterMediaEnum.pigVideo].contains(countMedia)) {
        if (_videoController.value == null || _videoController.value!.isEmpty) return EasyLoading.showError('请上传视频');
        params['input'] = _videoController.value!.map((e) => e.value).first;
      }
      if ([CountRegisterMediaEnum.cattleStream.value, CountRegisterMediaEnum.pigStream].contains(countMedia)) {
        if (_imgsController.value == null || _imgsController.value!.isEmpty) return EasyLoading.showError('请填写视频流地址');
        params['input'] = _streamStrController.text;
      }

      await RegisterApi.countInventory(params);
      context.go(RouteEnum.inventory.fullpath);
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
      appBar: AppBar(
        title: Text(RouteEnum.countRegister.title),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '基础盘点'),
            Tab(text: '监控视频盘点'),
          ]
        )
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
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
                            child: Text('牧场/圈舍', style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500)),
                          ),
                          Expanded(
                            child: PickerPastureWidget(
                              selectLast: SelectLast.pasture,
                              controller: _enclosureController,
                              options: enclosureList.value ?? [],
                            ),
                          )
                          
                        ],
                      ),
                    ),
                    RegisterTypeWidget<String>(defaultValue: countMedia, options: enumsStrValToOptions(CountRegisterMediaEnum.values), onChange: _changeRegisterMedia),
                    _getImgWidget,

                    const SizedBox(height: 50),
                    BlockButton(
                      onPressed: submitLoading ? null : () => _handleSubmit(enclosureList.value ?? []),
                      text: '盘点'
                    )
                  ],
                ),
              ),
            ),
          ),
          const ShedbizCameraWidget()
        ],
      )
    );
  }
}


class ShedbizCameraWidget extends ConsumerStatefulWidget {
  const ShedbizCameraWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShedbizCameraWidgetState();
}

class _ShedbizCameraWidgetState extends ConsumerState<ShedbizCameraWidget> {
  FijkPlayer livePlayer = FijkPlayer();
  String cameraText = '';
  String cameraVal = '';
  String videoUrl = '';

  List<PickerItem<String>> getPickerData(List<dynamic> data) {
    return data.map((e) {
      List<PickerItem<String>> children = [];
      e['cvrName'].forEach((key, value) {
        children.add(PickerItem<String>(
          text: Text(key),
          value: value,
        ));
      });
      return PickerItem<String>(
        text: Text(e['buildName']),
        value: e['buildName'],
        children: children,
      );
    }).toList();
  }

  void setCameraText(List<dynamic> data, List values) {
    final childrenList = [];
    String deviceName = '';
    for (var e in data) {
      e['cvrName']?.forEach((key, value) {
        childrenList.add({'name': key, 'value': value});
      });
    }
    Map<String, dynamic>? device = childrenList.singleWhere((e) => e['value'] == values.last);
    if (device != null) {
      deviceName = device['name'];
    }
    setState(() {
      cameraText = '${values.first}/$deviceName';
    });
  }


  submitHandle() async {
    if (videoUrl.isEmpty) return EasyLoading.showInfo('请选择有视频流的摄像头');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> params = {
      'input': videoUrl,
      'model': CountMediaEnum.stream.value,
      'source': prefs.getString(StorageKeyEnum.userId.value)
    };
    await RegisterApi.countInventory(params);
      context.go(RouteEnum.inventory.fullpath);
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List> shedCameraList = ref.watch(getShedCameraListProvider);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFE9E8E8))
              )
            ),
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                const SizedBox(
                  width: 80,
                  child: Text('摄像头', style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500)),
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Picker picker = Picker(
                        confirmText: '确定',
                        cancelText: '取消',
                        adapter: PickerDataAdapter(
                          data: getPickerData(shedCameraList.value ?? [])
                        ),
                        onConfirm: (picker, value) async {
                          final values = picker.getSelectedValues();
                          String deviceId = values.last;
                          setCameraText(shedCameraList.value ?? [], values);
                          Map<String, dynamic> res = await getCameraLiveUrlApi(deviceId);
                          livePlayer.setDataSource(res['url'], autoPlay: true);
                          setState(() {
                            videoUrl = res['url'] ?? '';
                          });
                        }
                      );
                      picker.showModal(context);
                    },
                    child: Text(cameraText),
                  )
                )
              ],
            ),
          ),
          if (videoUrl.isNotEmpty) AspectRatio(
            aspectRatio: 16 / 9,
            child: FijkView(player: livePlayer),
          ),
          
          Padding(
            padding: const EdgeInsets.only(top: 70),
            child: BlockButton(
              onPressed: submitHandle,
              text: '盘点',
            ),
          )
        ],
      ),
    );
  }
}