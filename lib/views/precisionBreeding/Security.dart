import 'package:easy_collect/utils/dialog.dart';
import 'package:easy_collect/widgets/List/PickerPastureWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_collect/api/precisionBreeding.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:easy_collect/api/security.dart';
import 'package:video_player/video_player.dart';

class SecurityPage extends ConsumerStatefulWidget {
  const SecurityPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SecurityPageState();
}

class _SecurityPageState extends ConsumerState<SecurityPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // 安防报警
  Widget get _securityList {
    final AsyncValue<List<EnclosureModel>> weightInfoTree = ref.watch(weightInfoTreeProvider);
    return Container(
      color: const Color(0xFFF1F5F9),
      child: Column(
        children: [
          Expanded(
            child: weightInfoTree.when(
              data: (data) {
                return ListWidget<SecurityPageFamily>(
                  pasture: PastureModel(
                    field: 'orgId',
                    options: data,
                  ),
                  provider: securityPageProvider,
                  builder: (rowData) {
                    return SecurityItem(rowData: rowData);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('加载数据时出错: $err')),
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('智能安防'),
        bottom: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: '安防报警'),
          Tab(text: '牧场视频'),
        ],
      ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _securityList,
          const _PastureVideo(),
        ],
      )
      
    );
  }
}

class SecurityItem extends StatelessWidget {
  final Map<String, dynamic> rowData;

  const SecurityItem({super.key, required this.rowData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF5D8FFD),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                rowData["dataType"] ?? '未知',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              rowData["orgName"] ?? '未知',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            // const Icon(Icons.chevron_right),
          ],
        ),
        const SizedBox(height: 12),
        Text('设备唯一码     ${rowData["devId"] ?? '未知'}', style: const TextStyle(color: Color(0xFF666666))),
        const SizedBox(height: 12),
        Text('牛耳标     ${rowData["animalNo"] ?? '未知'}', style: const TextStyle(color: Color(0xFF666666))),
        // const SizedBox(height: 12),
        // Text('性能值: ${rowData["dataValue"] ?? '未知'}', style: const TextStyle(color: Color(0xFF666666))),
        const SizedBox(height: 12),
        const Divider(height: 0.5, color: Color(0xFFE2E2E2)),
        const SizedBox(height: 12),
        Text('预警日期: ${rowData["date"] ?? '未知'}', style: const TextStyle(color: Color(0xFF999999))),
        // const SizedBox(height: 12),
        // Text('上传时间: ${rowData.updateTime ?? '未知'}', style: const TextStyle(color: Color(0xFF999999))),
      ],
    );
  }
}



class VideoCardModel {
  String? type;
  String camera;
  VideoPlayerController controller;
  VideoCardModel({this.type, required this.camera, required this.controller});
}

class _PastureVideo extends ConsumerStatefulWidget {
  const _PastureVideo();

  @override
  ConsumerState<ConsumerStatefulWidget>  createState() => _PastureVideoState();
}

class _PastureVideoState extends ConsumerState<_PastureVideo> {

  bool isOpenCamera = false;
  List<Map<String, dynamic>> cameraList = [];
  List<Map<String, dynamic>> checkedCameraList = [];
  List<VideoCardModel> _controllers = [];

  getCameraList(String pastureId) async {
    List<Map<String, dynamic>> data = await getCameraListApi(pastureId);
    setState(() {
      cameraList = data;
    });
  }
  handleCheckedCamera(int index, void Function(void Function()) setBottomSheetState) {
    setBottomSheetState(() {
      cameraList[index]['checked'] = !cameraList[index]['checked'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<EnclosureModel>> weightInfoTree = ref.watch(weightInfoTreeProvider);
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 300,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: PickerPastureWidget(
                isShed: true,
                options: weightInfoTree.value ?? [],
                onChange: (List<String> values) {
                  getCameraList(values.last);
                }
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isOpenCamera = true;
                });
                showConfirmModalBottomSheet(
                  context: context,
                  title: '缓存摄像头列表',
                  contentBuilder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (context, setBottomSheetState) {
                        return Expanded(
                          child: GridView.builder(
                            gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, //横轴三个子widget
                              childAspectRatio: 3
                            ),
                            
                            itemCount: cameraList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Row(
                                children: [
                                  Checkbox(value: cameraList[index]['checked'], onChanged: (value) => handleCheckedCamera(index, setBottomSheetState)),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => handleCheckedCamera(index, setBottomSheetState),
                                      child: Text('${cameraList[index]['name']}', style: const TextStyle(fontSize: 14, overflow: TextOverflow.ellipsis)),
                                    )
                                  )
                                  
                                ],
                              );
                            }
                          )
                        );
                      }
                    );
                  },
                  onConfirm: () async {
                    List<Map<String, dynamic>> checked = cameraList.where((element) => element['checked']).toList();
                    List<VideoCardModel> controllers = [];
                    for (var element in checked) {
                      controllers.add(VideoCardModel(
                        type: '监控视频',
                        camera: element['name'],
                        controller: VideoPlayerController.networkUrl(Uri.parse(element['monitorUrl']))..initialize()
                      ));
                      controllers.add(VideoCardModel(
                        type: 'AI视觉分析',
                        camera: element['name'], 
                        controller: VideoPlayerController.networkUrl(Uri.parse(element['algorithmUrl']))..initialize()
                      ));
                    }
                    setState(() {
                      checkedCameraList = checked;
                      _controllers = controllers;
                    });
                  }
                );
              },
              child: Row(
                children: [
                  const Text('摄像头'),
                  Icon( isOpenCamera ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up)
                ],
              ),
            )
          ],
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GridView.builder(
              itemCount: _controllers.length,
              gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .5,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (BuildContext context, int index) {
                VideoCardModel videoCard = _controllers[index];
                print(videoCard.controller.value.isInitialized);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    videoCard.controller.value.isInitialized ? GestureDetector(
                      onTap: () {
                        setState(() {
                          if (videoCard.controller.value.isPlaying) {
                            videoCard.controller.pause();
                          } else {
                            videoCard.controller.play();
                          }
                        });
                      },
                      child: AspectRatio(
                        aspectRatio: videoCard.controller.value.aspectRatio,
                        child: VideoPlayer(videoCard.controller),
                      )
                    )
                     : const SizedBox.shrink(),
                    Text('${videoCard.type}-${videoCard.camera}')
                  ],
                );
              }
            ),
          )
        )
        
      ],
    );
  }
}