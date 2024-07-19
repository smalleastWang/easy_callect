import 'package:easy_collect/models/mortgage/Mortgage.dart';
import 'package:easy_collect/utils/http/request.dart';

class MyApi {
  // 养殖规模
  static Future<Mortgage> getMortgageInfo(Map<String, dynamic> params) async {
    Map<String, dynamic> res = await HttpUtils.get('/biz/monitoring/mortgage', params: params);
    Mortgage mortgage = Mortgage.fromJson(res);
    print('res: $res');
    return mortgage;
  }
}