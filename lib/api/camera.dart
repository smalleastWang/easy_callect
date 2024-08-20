import 'package:easy_collect/models/PageVo.dart';
import 'package:easy_collect/utils/http/request.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'camera.g.dart';

// 摄像头列表
@riverpod
Future<PageVoModel> cameraPage(CameraPageRef ref, Map<String, dynamic> params) async {
  Map<String, dynamic> res = await HttpUtils.get('/biz/camera/page', params: params);
  PageVoModel data = PageVoModel.fromJson(res);
  if (data.current != 1 && ref.state.hasValue) {
    data.records.insertAll(0, ref.state.value!.records);
  }
  return data;
}