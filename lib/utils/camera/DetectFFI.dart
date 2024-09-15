import 'dart:ffi';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:ffi/ffi.dart';
import 'package:detection_plugin/detection_plugin_bindings_generated.dart' as DetectionLib;
import 'package:flutter/services.dart';
import 'package:easy_collect/utils/camera/imageBean.dart';
import 'package:easy_collect/utils/camera/CameraxUtils.dart';
import 'package:isolate_manager/isolate_manager.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ImagePackage;


class DetObject {
  int label = 0;
  double prob = 0;
  Rect rect = Rect.zero;
  bool success = true;

  DetObject({
    required this.rect,
    required this.prob,
    required this.label
  });
}

@pragma('vm:entry-point')
Future<dynamic> handleDetectFace(dynamic data) async{
  final objects = <DetObject>[];

  if (data is! CameraxDetectorBean){
    return objects;
  }

  if (DetectionModel.isEmpty()){
    return DetectionModel.getInstance().init(data);
  }

  if(!data.statue){
    DetectionModel.getInstance().clear();
  }

  var detectResult = DetectionModel
      .getInstance()
      .detLibBind
      .detectResultCreate();
  int errorFlag = -1;
  // input camera
  if(data.cameraImage != null) {
    final pixels = concatenatePlanes(data.cameraImage!.planes);
    final pixelsPtr = calloc.allocate<Uint8>(pixels.length);
    for (int i = 0; i < pixels.length; i++) {
      pixelsPtr[i] = pixels[i];
    }

    int pixelType = 0;
    if(data.cameraImage!.format.group == ImageFormatGroup.yuv420){
      pixelType = DetectionLib.PixelType.PIXEL_YUV;
    }
    else if(data.cameraImage!.format.group == ImageFormatGroup.bgra8888){
      pixelType = DetectionLib.PixelType.PIXEL_BGRA;
    }
    else {
      return objects;
    }

    errorFlag = DetectionModel
        .getInstance()
        .detLibBind
        .detectWithPixelsByV5(
        pixelsPtr,
        pixelType,
        DetectionLib.DETType.FACE_TYPE,
        data.width!,
        data.height!,
        detectResult);
  }
  // input bgr image
  if(data.imageBgr != null){
    final pixels = data.imageBgr!.getBytes(order: ImagePackage.ChannelOrder.bgr);
    final pixelsPtr = calloc.allocate<Uint8>(pixels.length);
    for (int i = 0; i < pixels.length; i++) {
      pixelsPtr[i] = pixels[i];
    }
    errorFlag = DetectionModel
        .getInstance()
        .detLibBind
        .detectWithPixelsByV5(
        pixelsPtr,
        DetectionLib.PixelType.PIXEL_BGR,
        DetectionLib.DETType.FACE_TYPE,
        data.width!,
        data.height!,
        detectResult);
  }
  // get FFi box
  if (errorFlag == DetectionLib.STATUS_OK) {
    final num = detectResult.ref.object_num;
    for (int i = 0; i < num; i++) {
      final o = detectResult.ref.object[0];
      final obj = DetObject(
          prob: o.prob,
          label: o.label,
          rect: Rect.fromLTRB(o.rect.x, o.rect.y,
              o.rect.w + o.rect.x, o.rect.y + o.rect.h)
      );
      objects.add(obj);
    }
  }
  DetectionModel.getInstance().detLibBind.detectResultDestroy(detectResult);
  return objects;
}
class DetectionModel{
  late DynamicLibrary detDylib;
  late DetectionLib.DetectionPluginBindings detLibBind;
  static DetectionModel? _instance;

  DetectionModel._internal();

  static DetectionModel getInstance(){
    _instance ??= DetectionModel._internal();
    return _instance!;
  }

  static bool isEmpty() => _instance == null;

  bool init(CameraxDetectorBean data) {
    if(Platform.isAndroid || Platform.isLinux){
      detDylib = DynamicLibrary.open('libdetection_plugin.so');
    }
    else if(Platform.isIOS || Platform.isMacOS){
      // detDylib = DynamicLibrary.open('detection_plugin.framework/detection_plugin');
      detDylib = DynamicLibrary.process();
    }
    else{
      return false;
    }

    detLibBind = DetectionLib.DetectionPluginBindings(detDylib);

    final modelPathUtf8 = data.modelPath!.toNativeUtf8();
    final paramPathUtf8 = data.paramPath!.toNativeUtf8();
    int flag = detLibBind.modelCreate(modelPathUtf8.cast(), paramPathUtf8.cast());
    calloc
      ..free(modelPathUtf8)
      ..free(paramPathUtf8);
    if(flag != 0){
      return false;
    }
    return true;
  }

  void clear(){
    detLibBind.modelDestroy();
  }

}



class DetFFI {
  static DetFFI? _instance;
  IsolateManager? _isolateManagerFaceCamera;
  IsolateManager? _isolateManagerBodyCamera;
  IsolateManager? _isolateManagerPigBodyCamera;

  static DetFFI getInstance() {
    _instance ??= DetFFI._internal();
    return _instance!;
  }

  DetFFI._internal() {
    // 初始化代码
  }

  Future<bool> init() async{
    // 牛脸
    _isolateManagerFaceCamera = IsolateManager.create(handleDetectFace);
    await _isolateManagerFaceCamera!.start();
    await _isolateManagerFaceCamera!.compute(CameraxDetectorBean(
      modelPath: await _copyAssetToLocal('assets/bestLite-optFP16.bin', package: 'detection_plugin', notCopyIfExist: false),
      paramPath: await _copyAssetToLocal('assets/bestLite-optFP16.param', package: 'detection_plugin', notCopyIfExist: false)
    ));
    // 牛背
    _isolateManagerBodyCamera = IsolateManager.create(handleDetectFace);
    await _isolateManagerBodyCamera!.start();
    await _isolateManagerBodyCamera!.compute(CameraxDetectorBean(
      modelPath: await _copyAssetToLocal('assets/bestLiteBack-optFP16.bin', package: 'detection_plugin', notCopyIfExist: false),
      paramPath: await _copyAssetToLocal('assets/bestLiteBack-optFP16.param', package: 'detection_plugin', notCopyIfExist: false)
    ));
    // 猪背
    _isolateManagerPigBodyCamera = IsolateManager.create(handleDetectFace);
    await _isolateManagerPigBodyCamera!.start();
    await _isolateManagerPigBodyCamera!.compute(CameraxDetectorBean(
      modelPath: await _copyAssetToLocal('assets/pig_body.bin', package: 'detection_plugin', notCopyIfExist: false),
      paramPath: await _copyAssetToLocal('assets/pig_body.param', package: 'detection_plugin', notCopyIfExist: false)
    ));
    
    return true;
  }

  // 牛脸相机识别
  Future<List<DetObject>> detectFaceCamera(CameraImage image) async{
    return await _isolateManagerFaceCamera!.compute(CameraxDetectorBean(
      width: image.width,
      height: image.height,
      cameraImage: image
    ));
  }
  // 牛脸图片识别
  Future<List<DetObject>> detectFaceImage(ImagePackage.Image image) async{
    return await _isolateManagerFaceCamera!.compute(CameraxDetectorBean(
      width: image.width,
      height: image.height,
      imageBgr: image,
    ));
  }

  // 牛背相机识别
  Future<List<DetObject>> detectBodyCamera(CameraImage image) async{
    return await _isolateManagerBodyCamera!.compute(CameraxDetectorBean(
      width: image.width,
      height: image.height,
      cameraImage: image
    ));
  }
  // 牛背图片识别
  Future<List<DetObject>> detectBodyImage(ImagePackage.Image image) async{
    return await _isolateManagerBodyCamera!.compute(CameraxDetectorBean(
      width: image.width,
      height: image.height,
      imageBgr: image,
    ));
  }
  // 猪背相机识别
  Future<List<DetObject>> detectPigBodyCamera(CameraImage image) async{
    return await _isolateManagerPigBodyCamera!.compute(CameraxDetectorBean(
      width: image.width,
      height: image.height,
      cameraImage: image
    ));
  }
  // 猪背图片识别
  Future<List<DetObject>> detectPigBodyImage(ImagePackage.Image image) async{
    return await _isolateManagerPigBodyCamera!.compute(CameraxDetectorBean(
      width: image.width,
      height: image.height,
      imageBgr: image,
    ));
  }

  void clear() async{
    CameraxDetectorBean dataBean = CameraxDetectorBean();
    dataBean.statue = false;
    await _isolateManagerFaceCamera!.compute(dataBean).then((value){
      _isolateManagerFaceCamera!.stop();
    });
  }

}

Future<String> _copyAssetToLocal(String assetName,
    {AssetBundle? bundle,
      String? package,
      bool notCopyIfExist = false}) async {
  final docDir = await getApplicationDocumentsDirectory();
  final filePath = join(docDir.path, assetName);

  if (notCopyIfExist &&
      FileSystemEntity.typeSync(filePath) != FileSystemEntityType.notFound) {
    return filePath;
  }

  final keyName =
  package == null ? assetName : 'packages/$package/$assetName';
  final data = await (bundle ?? rootBundle).load(keyName);

  final file = File(filePath)..createSync(recursive: true);
  await file.writeAsBytes(data.buffer.asUint8List(), flush: true);
  return file.path;
}