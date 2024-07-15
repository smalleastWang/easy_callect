import 'package:camera/camera.dart';
import 'package:image/image.dart' as ImagePackage;

enum DetectionType{
  cowface, cowbody, pigbody
}

abstract class DataBean{

}

class CameraxDetectorBean extends DataBean {
  CameraImage? cameraImage;
  ImagePackage.Image? imageBgr;
  bool statue = true;
  String? modelPath;
  String? paramPath;
  int? height;
  int? width;

  CameraxDetectorBean();

// final ByteBuffer buffer = await cameraImage.planes.first.bytes;
}