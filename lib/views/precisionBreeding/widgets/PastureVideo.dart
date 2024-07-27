

import 'package:chewie/chewie.dart';
import 'package:easy_collect/api/precisionBreeding.dart';
import 'package:easy_collect/api/security.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/utils/dialog.dart';
import 'package:easy_collect/widgets/List/PickerPastureWidget.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

class VideoCardModel {
  String? type;
  String camera;
  ChewieController? controller;
  FijkPlayer? livePlayer;
  VideoCardModel({this.type, required this.camera, this.controller, this.livePlayer});
}

enum VideoType {
  demo,
  live
}

class PastureVideo extends ConsumerStatefulWidget {
  const PastureVideo({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget>  createState() => _PastureVideoState();
}

class _PastureVideoState extends ConsumerState<PastureVideo> {

  VideoType videoType = VideoType.demo;
  List<Map<String, dynamic>> cameraList = [];
  List<Map<String, dynamic>> checkedCameraList = [];
  List<VideoCardModel> _videoList = [];

  _getCameraList(List<String> values) async {
    List<Map<String, dynamic>> data = await getCameraListApi(values.last);
    setState(() {
      cameraList = data;
    });
  }
  _handleCheckedCamera(int index, void Function(void Function()) setBottomSheetState) {
    setBottomSheetState(() {
      cameraList[index]['checked'] = !cameraList[index]['checked'];
    });
  }

  _handleCameraConfirm() async {
    List<Map<String, dynamic>> checked = cameraList.where((element) => element['checked']).toList();
    List<VideoCardModel> videoList = [];
    for (var element in checked) {
      if (videoType == VideoType.demo) {
        videoList.add(VideoCardModel(
          type: '监控视频',
          camera: element['name'],
          controller: ChewieController(videoPlayerController: VideoPlayerController.networkUrl(Uri.parse(element['monitorUrl']))..initialize())
        ));
        videoList.add(VideoCardModel(
          type: 'AI视觉分析',
          camera: element['name'], 
          controller: ChewieController(videoPlayerController: VideoPlayerController.networkUrl(Uri.parse(element['algorithmUrl']))..initialize())
        ));
      } else if (videoType == VideoType.live) {
        // Map<String, dynamic> data =  await getCameraLiveUrlApi(element['easyCvrId']);
        final FijkPlayer player = FijkPlayer();
        // player.setDataSource(data['url'], autoPlay: true);
        player.setDataSource('http://36.133.213.146:18000/flv/live/34020000001320001278_34020000001320001278_0200001278.flv', autoPlay: true);
        videoList.add(VideoCardModel(
          camera: element['name'],
          // controller: VideoPlayerController.networkUrl(Uri.parse(data['url']))..initialize()
          livePlayer: player
        ));
      }
    }
    setState(() {
      checkedCameraList = checked;
      _videoList = videoList;
    });
  }

  _cameraBottomSheet() {
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
                      Checkbox(value: cameraList[index]['checked'], onChanged: (value) => _handleCheckedCamera(index, setBottomSheetState)),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _handleCheckedCamera(index, setBottomSheetState),
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
      onConfirm: _handleCameraConfirm
    );
  }
  @override
  void dispose() {
    super.dispose();
    for (var element in _videoList) {
      if (element.controller != null) {
        element.controller!.dispose();
      }
      if (element.livePlayer != null) {
        element.livePlayer!.release();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
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
                onChange: _getCameraList
              ),
            ),
            GestureDetector(
              onTap: _cameraBottomSheet,
              child: const Row(
                children: [
                  Text('摄像头'),
                  Icon(Icons.keyboard_arrow_down)
                ],
              ),
            )
          ],
        ),
        
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: const BoxDecoration(
              color: Color(0xffF1F5F9)
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            videoType = VideoType.demo;
                            _videoList = [];
                          });
                        },
                        child: Container(
                          height: 32,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.white
                          ),
                          child: Text('演示视频', style: TextStyle(color:  videoType == VideoType.demo ? Theme.of(context).primaryColor : const Color(0xff333333))),
                        ),
                      )
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            videoType = VideoType.live;
                            _videoList = [];
                          });
                        },
                        child: Container(
                          height: 32,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.white
                          ),
                          alignment: Alignment.center,
                          child: Text('实时监控', style: TextStyle(color:  videoType == VideoType.live ? Theme.of(context).primaryColor : const Color(0xff333333))),
                        ),
                      )
                    )
                  ],
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    margin: mediaQuery.padding,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6)
                    ),
                    child:  _videoList.isNotEmpty ? GridView.builder(
                      itemCount: _videoList.length,
                      gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.3,
                        // mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        VideoCardModel videoCard = _videoList[index];
                        if (videoCard.controller == null && videoCard.livePlayer == null) {
                          return const Center(child: Text('传参错误'));
                        }
                        // print(videoCard.controller.value.isInitialized);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: videoCard.controller != null ? Chewie(controller: videoCard.controller!) : FijkView(player: videoCard.livePlayer!),
                              ),
                            ),
                            Text('${videoCard.type != null ? '${videoCard.type}-' : ''}${videoCard.camera}')
                          ],
                        );
                      }
                    ) : const Center(child: Text('请选择牧场和摄像头')),
                  )
                )
              ],
            )
          )
        )
      ],
    );
  }
}

