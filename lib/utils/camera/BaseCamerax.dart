import 'dart:async';
import 'dart:io';
import 'package:easy_collect/utils/camera/CameraxUtils.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:camera/camera.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_collect/utils/camera/Config.dart';
import 'package:easy_collect/utils/camera/DetectFFI.dart';
import 'package:go_router/go_router.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'dart:ui' as ui;

class CameraMlVision extends StatefulWidget {
  final WidgetBuilder? loadingBuilder;
  final AppErrorWidgetBuilder? errorBuilder;
  final CameraLensDirection cameraLensDirection;
  final ResolutionPreset? resolution;
  final Function? onDispose;
  final EnumTaskMode mTaskMode;

  const CameraMlVision(
      {super.key,
      this.loadingBuilder,
      this.errorBuilder,
      this.cameraLensDirection = CameraLensDirection.back,
      this.resolution,
      this.onDispose,
      required this.mTaskMode});

  @override
  CameraMlVisionState createState() => CameraMlVisionState();
}

class CameraMlVisionState extends State<CameraMlVision>
    with WidgetsBindingObserver {
  final List<XFile> _pickImages = [];
  final _visibilityKey = UniqueKey();
  CameraController? _cameraController;
  ImageRotation? _rotation;
  CameraState _cameraMlVisionState = CameraState.ready;
  CameraError _cameraError = CameraError.unknown;
  bool _alreadyCheckingImage = false;
  bool _isStreaming = false;
  bool _isDeactivate = false;
  ui.Image? mOverlayImage;
  int fps = 0;
  DetectionObject? _mDetectionObject;
  bool isDetected = false;

  @override
  void initState() {
    if (mOverlayImage == null) {
      loadImage(getOverlayPath(widget.mTaskMode));
    }
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initialize();
  }

  @override
  void didUpdateWidget(CameraMlVision oldWidget) {
    if (mOverlayImage == null) {
      loadImage(getOverlayPath(widget.mTaskMode));
    }
    if (oldWidget.resolution != widget.resolution) {
      _initialize();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _stop(true).then((value) => _cameraController?.dispose());
    } else if (state == AppLifecycleState.resumed && _isStreaming) {
      _initialize();
    }
  }

  Future<void> stop() async {
    if (_cameraController != null) {
      await _stop(true);
      try {
        // final image = await _cameraController!.takePicture();
        // setState(() {
        //   _pickImages.add(image);
        // });
      } on PlatformException catch (e) {
        debugPrint('$e');
      }
    }
  }

  Future<void> photograph() async {
    if (_cameraController != null) {
      try {
        final image = await _cameraController!.takePicture();
        img.Image? i = await img.decodeImageFile(image.path);
        if (_mDetectionObject == null || i == null) return;
        Rect rect = _mDetectionObject!.rect;

        double xRate = i.width / cameraController!.value.previewSize!.height;
        double yRate = i.height / cameraController!.value.previewSize!.width;

        int x = (rect.left * xRate).toInt();
        int y = (rect.top * yRate).toInt();
        int width = (rect.width * xRate).toInt();
        int height = (rect.height * yRate).toInt();

        img.Image cropImg = img.copyCrop(i, x: x, y: y, width: width, height: height);

        Uint8List cropBytes = Uint8List.fromList(img.encodePng(cropImg));

        File file = File(image.path);
        file.writeAsBytesSync(cropBytes);
        XFile cropImgFile  = XFile(image.path, bytes: cropBytes);
        setState(() {
          _pickImages.add(cropImgFile);
        });
      } on PlatformException catch (e) {
        debugPrint('$e');
      }
    }
  }

  Future<void> _stop(bool silently) {
    final completer = Completer();
    scheduleMicrotask(() async {
      if (_cameraController?.value.isStreamingImages == true && mounted) {
        await _cameraController!.stopImageStream().catchError((_) {});
      }

      if (silently) {
        _isStreaming = false;
      } else {
        setState(() {
          _isStreaming = false;
        });
      }
      completer.complete();
    });
    return completer.future;
  }

  void start() {
    if (_cameraController != null) {
      _start();
    }
  }

  void _start() {
    _cameraController!.startImageStream(_processImage);
    setState(() {
      _isStreaming = true;
    });
  }

  CameraValue? get cameraValue => _cameraController?.value;

  ImageRotation? get imageRotation => _rotation;

  Future<void> Function() get prepareForVideoRecording =>
      _cameraController!.prepareForVideoRecording;

  Future<void> startVideoRecording() async {
    await _cameraController!.stopImageStream();
    return _cameraController!.startVideoRecording();
  }

  Future<XFile> stopVideoRecording(String path) async {
    final file = await _cameraController!.stopVideoRecording();
    await _cameraController!.startImageStream(_processImage);
    return file;
  }

  CameraController? get cameraController => _cameraController;

  Future<XFile> takePicture(String path) async {
    await _stop(true);
    final image = await _cameraController!.takePicture();
    _start();
    return image;
  }

  Future<void> flash(FlashMode mode) async {
    await _cameraController!.setFlashMode(mode);
  }

  Future<void> focus(FocusMode mode) async {
    await _cameraController!.setFocusMode(mode);
  }

  Future<void> focusPoint(Offset point) async {
    await _cameraController!.setFocusPoint(point);
  }

  Future<void> zoom(double zoom) async {
    await _cameraController!.setZoomLevel(zoom);
  }

  Future<void> exposure(ExposureMode mode) async {
    await _cameraController!.setExposureMode(mode);
  }

  Future<void> exposureOffset(double offset) async {
    await _cameraController!.setExposureOffset(offset);
  }

  Future<void> exposurePoint(Offset offset) async {
    await _cameraController!.setExposurePoint(offset);
  }

  Future loadImage(String path) async {
    final data = await rootBundle.load(path);
    final bytes = data.buffer.asUint8List();
    final image = await decodeImageFromList(bytes);
    mOverlayImage = image;
  }

  Future<void> _initialize() async {
    final cameras = await availableCameras();
    var idx =
        cameras.indexWhere((c) => c.lensDirection == CameraLensDirection.back);
    if (idx < 0) {
      EasyLoading.showToast('未检测到相机',
          toastPosition: EasyLoadingToastPosition.top);
      return;
    }

    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt < 21) {
        EasyLoading.showToast(
            'Camera plugin doesn\'t support android under version 21',
            toastPosition: EasyLoadingToastPosition.top);
        if (mounted) {
          setState(() {
            _cameraMlVisionState = CameraState.error;
            _cameraError = CameraError.androidVersionNotSupported;
          });
        }
        return;
      }
    }

    final description = await getCamera(widget.cameraLensDirection);
    if (description == null) {
      _cameraMlVisionState = CameraState.error;
      _cameraError = CameraError.noCameraAvailable;
      return;
    }
    if (_cameraController != null) {
      await _stop(true);
      await _cameraController?.dispose();
    }
    _cameraController = CameraController(
      description,
      widget.resolution ?? ResolutionPreset.high,
      enableAudio: false,
    );
    if (!mounted) {
      return;
    }

    try {
      await _cameraController!.initialize();
    } catch (ex, stack) {
      debugPrint('$ex, $stack');
      EasyLoading.showToast('初始化相机失败',
          toastPosition: EasyLoadingToastPosition.top);
      if (mounted) {
        setState(() {
          _cameraMlVisionState = CameraState.error;
          _cameraError = CameraError.cantInitializeCamera;
        });
      }
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _cameraMlVisionState = CameraState.ready;
    });
    _rotation = rotationIntToImageRotation(
      description.sensorOrientation,
    );

    // fixme hacky technique to avoid having black screen on some android devices
    await Future.delayed(const Duration(milliseconds: 200));
    start();
  }

  @override
  void dispose() {
    if (widget.onDispose != null) {
      widget.onDispose!();
    }
    if (_cameraController != null) {
      _stop(true).then((value) {
        _cameraController?.dispose();
      });
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraMlVisionState == CameraState.error) {
      return widget.errorBuilder == null
          ? Center(child: Text('$_cameraMlVisionState $_cameraError'))
          : widget.errorBuilder!(context, _cameraError);
    }

    Widget cameraPreviewBox = Stack(fit: StackFit.passthrough, children: [
      _isStreaming ? CameraPreview(_cameraController!) : const SizedBox.shrink(),
      if (cameraController?.value.isInitialized == true)
        AspectRatio(
          aspectRatio: _isLandscape()
              ? cameraController!.value.aspectRatio
              : (1 / cameraController!.value.aspectRatio),
          child: CustomPaint(
            painter: ObjectPainter(
                objectRect: _mDetectionObject,
                imageOverlay: mOverlayImage,
                mSize: Size(cameraController!.value.previewSize!.height,
                    cameraController!.value.previewSize!.width)),
          ),
        ),
        // 拍照按钮
        Positioned(
          left: 0,
          right: 0,
          bottom: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(width: 80, height: 80),
              isDetected ? InkWell(
                onTap: () async {
                  // await stop();
                  photograph();
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.red,
                    border: Border.all(width: 28, color: Colors.white),
                  ),
                ),
              ) : const SizedBox.shrink(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Theme.of(context).primaryColor.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0), // 设置圆角半径为6.0
                  ),
                ),
                onPressed: () async {
                  if (_pickImages.length > 20) {
                    EasyLoading.showToast('最多连续拍20张');
                    return;
                  }
                  await stop();
                  context.pop(_pickImages);
                },
                child: const Text('完成', style: TextStyle(color: Colors.white)),
              )
            ],
          )
        ),
        Positioned(
          left: 10,
          right: 10,
          bottom: 0,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _pickImages.map((XFile file) {
                return Container(
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6)
                  ),
                  margin: const EdgeInsets.only(right: 8),
                  child: Image.file(File(file.path)),
                );
              }).toList()
          ),
          ) 
        )
        
    ]);

    return VisibilityDetector(
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction == 0) {
          //invisible stop the streaming
          _isDeactivate = true;
          _stop(true);
        } else if (_isDeactivate) {
          //visible restart streaming if needed
          _isDeactivate = false;
          _start();
        }
      },
      key: _visibilityKey,
      child: cameraPreviewBox,
    );
  }

  DeviceOrientation? _getApplicableOrientation() {
    return (cameraController?.value.isRecordingVideo ?? false)
        ? cameraController?.value.recordingOrientation
        : (cameraController?.value.lockedCaptureOrientation ??
            cameraController?.value.deviceOrientation);
  }

  bool _isLandscape() {
    return [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]
        .contains(_getApplicableOrientation());
  }

  void _processImage(CameraImage cameraImage) async {
    if (!_alreadyCheckingImage && mounted && fps >= 15) {
      _alreadyCheckingImage = true;

      Stopwatch stopwatch = Stopwatch();
      stopwatch.start(); // 开始计时
      debugPrint("test ${cameraImage.format.group.toString()}");
      await DetFFI.getInstance().detectFaceCamera(cameraImage).then((value) {
        stopwatch.stop(); // 停止计时
        debugPrint('执行时间: ${stopwatch.elapsedMilliseconds} 毫秒');
        setState(() {
          isDetected = value.isNotEmpty;
        });
        if (value.isNotEmpty) {
          DetObject object = value[0];

          setState(() {
            if (_mDetectionObject == null) {
              _mDetectionObject =
                  DetectionObject(prob: object.prob, rect: object.rect);
            } else {
              _mDetectionObject!.rect = object.rect;
              _mDetectionObject!.prob = object.prob;
            }
          });
        } else {
          setState(() {
            _mDetectionObject = null;
          });
          EasyLoading.showToast('未检测到目标',
              toastPosition: EasyLoadingToastPosition.top);
        }
        _alreadyCheckingImage = false;
        fps = 0;
      });
    }
    ++fps;
  }

  void toggle() {
    if (_isStreaming && _cameraController!.value.isStreamingImages) {
      stop();
    } else {
      start();
    }
  }
}
