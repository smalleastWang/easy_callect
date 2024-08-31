
import 'package:camera/camera.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_collect/utils/camera/Config.dart';
import 'package:easy_collect/utils/camera/imageBean.dart';
import 'dart:ui' as ui;


typedef HandleDetection<T> = Future<T> Function(CameraxDetectorBean image);
typedef AppErrorWidgetBuilder = Widget Function(
    BuildContext context, CameraError error);


enum CameraError {
  unknown,
  cantInitializeCamera,
  androidVersionNotSupported,
  noCameraAvailable,
}

enum CameraState {
  loading,
  error,
  ready,
}

enum ImageRotation { rotation0, rotation90, rotation180, rotation270 }

Future<CameraDescription?> getCamera(CameraLensDirection dir) async {
  final cameras = await availableCameras();
  final camera = cameras.firstWhereOrNull((camera) => camera.lensDirection == dir);
  return camera ?? (cameras.isEmpty ? null : cameras.first);
}

Uint8List concatenatePlanes(List<Plane> planes) {
  final allBytes = WriteBuffer();
  for (var plane in planes) {
    allBytes.putUint8List(plane.bytes);
  }
  return allBytes
      .done()
      .buffer
      .asUint8List();
}

Uint8List convertCameraImageToBgr(CameraImage cameraImage) {
  // 获取图像的宽度和高度
  final int width = cameraImage.width;
  final int height = cameraImage.height;

  // 创建一个与原始图像尺寸相同的BGR数组
  Uint8List bgrBytes = Uint8List(width * height * 3);

  // 将RGB数据复制到BGR数组中，注意RGB和BGR格式的区别
  for (int i = 0; i < height; i++) {
    for (int j = 0; j < width; j++) {
      final int index = i * width * 4 + j * 4;
      final int indexBgr = i * width * 3 + j * 3;

      // R
      bgrBytes[indexBgr] = cameraImage.planes[0].bytes[index];
      // G
      bgrBytes[indexBgr + 1] = cameraImage.planes[0].bytes[index + 1];
      // B
      bgrBytes[indexBgr + 2] = cameraImage.planes[0].bytes[index + 2];
    }
  }

  return bgrBytes;
}

ImageRotation rotationIntToImageRotation(int rotation) {
  switch (rotation) {
    case 0:
      return ImageRotation.rotation0;
    case 90:
      return ImageRotation.rotation90;
    case 180:
      return ImageRotation.rotation180;
    default:
      assert(rotation == 270);
      return ImageRotation.rotation270;
  }
}


class DetectionObject {
  double prob;
  Rect rect;
  DetectionObject({required this.prob,required this.rect});
}

class ObjectPainter extends CustomPainter {
  final DetectionObject? objectRect;

  final ui.Image? imageOverlay;

  final Size? mSize;

  final double widthFactor = 0.5; // 图片宽度与分配空间宽度的比例

  final double heightFactor = 0.3; // 图片高度与分配空间高度的比例

  ObjectPainter({required this.objectRect,
                  required this.imageOverlay,
                  required this.mSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if(imageOverlay != null){
      double width = size.width * widthFactor;
      double height = size.height * heightFactor;
      // 绘制图片
      Rect imageRect = Rect.fromLTWH((size.width - width) / 2,
          (size.height - height) / 2, width, height);
      canvas.drawImageRect(imageOverlay!,
          Rect.fromLTWH(0, 0, imageOverlay!.width.toDouble(),
              imageOverlay!.height.toDouble()), imageRect,    Paint()
      );
    }
    if(objectRect != null){
      _drawBox(canvas, size);
    }
  }

  void _drawBox(Canvas canvas, Size size){
    Color lineColor;
    int lineWidth = 20;

    double scaleX = size.width / mSize!.width;
    double scaleY = size.height / mSize!.height;


    if(objectRect!.prob < 0.6){
      lineColor = Colors.red;
    }
    else if(objectRect!.prob < 0.8){
      lineColor = Colors.yellow;
    }
    else{
      lineColor = Colors.green;
    }
    Paint paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeWidth = 3;
    Rect tmpRect = Rect.fromLTRB(objectRect!.rect.left*scaleX, objectRect!.rect.top*scaleY,
        objectRect!.rect.right*scaleX, objectRect!.rect.bottom*scaleY);
    Offset lt = tmpRect.topLeft;
    Offset rt = tmpRect.topRight;
    Offset lb = tmpRect.bottomLeft;
    Offset rb = tmpRect.bottomRight;
    canvas.drawLine(lt, Offset(lt.dx + lineWidth, lt.dy), paint);
    canvas.drawLine(lt, Offset(lt.dx, lt.dy + lineWidth), paint);

    canvas.drawLine(rt, Offset(rt.dx, rt.dy + lineWidth), paint);
    canvas.drawLine(rt, Offset(rt.dx - lineWidth, rt.dy), paint);

    canvas.drawLine(lb, Offset(lb.dx + lineWidth, lb.dy), paint);
    canvas.drawLine(lb, Offset(lb.dx, lb.dy - lineWidth), paint);

    canvas.drawLine(rb, Offset(rb.dx, rb.dy - lineWidth), paint);
    canvas.drawLine(rb, Offset(rb.dx - lineWidth, rb.dy), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

String getOverlayPath(EnumTaskMode taskMode) {
  switch (taskMode){
    case EnumTaskMode.cowFaceRegister:
      return "assets/images/cow_face_register.png";
    case EnumTaskMode.cowFaceIdentify:
      return "assets/images/cow_face_pattern.png";
    case EnumTaskMode.cowBodyRegister:
      return "assets/images/cow_body_register.png";
    case EnumTaskMode.cowBodyIdentify:
      return "assets/images/cow_face_pattern.png";
    case EnumTaskMode.pigBodyRegister:
      return "assets/images/pig_body_register.png";
    case EnumTaskMode.pigBodyIdentify:
    return "assets/images/pig_body_identify.png";
  }
}
