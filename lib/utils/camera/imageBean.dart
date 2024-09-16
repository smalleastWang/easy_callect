import 'package:camera/camera.dart';
import 'package:image/image.dart' as ImagePackage;

enum DetectionType {
  cowface('bestLite-optFP16'),
  cowbody('bestLiteBack-optFP16'),
  pigbody('pig_body');
  final String value;
  
  const DetectionType(this.value);
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

  CameraxDetectorBean({
    this.cameraImage,
    this.imageBgr,
    this.statue = true,
    this.modelPath,
    this.paramPath,
    this.height,
    this.width
  });

// final ByteBuffer buffer = await cameraImage.planes.first.bytes;
}