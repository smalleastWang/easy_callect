enum RouteEnum {

  home('/', '首页'),
  cameraRegister('/cameraRegister', '首页'),
  login('/login', '登录'),
  userInfo('/userInfo', '用户基本信息'),


  // 智慧保险
  insurance('/insurance', '智慧保险'),
  standardVerification('standardVerification', '验标注册', '/insurance/standardVerification'),
  surveyCompared('surveyCompared', '查勘对比', '/insurance/surveyCompared'),
  orderList('orderList', '订单列表', '/insurance/orderList'),
  countRegister('countRegister', '计数盘点', '/insurance/countRegister'),

  // 养殖金融
  finance('/finance', '养殖金融'),
  cattleRegiter('cattleRegiter', '牛只注册','/finance/cattleRegiter'),
  financeCount('financeCount', '计数盘点','/finance/financeCount'),
  cattleDiscern('cattleDiscern', '牛只识别','/finance/cattleDiscern'),
  financeVideo('financeVideo', '实时视频','/finance/financeVideo'),

  // 精准养殖
  precisionBreeding('/precisionBreeding', '精准养殖'),
  inventory('inventory', '盘点管理', '/precisionBreeding/inventory'),
  performance('performance', '性能测定', '/precisionBreeding/performance'),
  weight('weight', '智能估重', '/precisionBreeding/weight'),
  behavior('behavior', '行为分析', '/precisionBreeding/behavior'),
  health('health', '健康监测', '/precisionBreeding/health'),
  position('position', '实时定位', '/precisionBreeding/position'),
  security('security', '智能安防', '/precisionBreeding/security'),
  pen('pen', '圈舍管理', '/precisionBreeding/pen'),



  // 行业监督
  supervision('/supervision', '行业监督'),
  breedingScale('breedingScale', '养殖规模', '/supervision/breedingScale'),
  mortgageInfo('mortgageInfo', '抵押信息', '/supervision/mortgageInfo'),
  insureInfo('insureInfo', '投保信息', '/supervision/insureInfo'),
  healthCheck('healthCheck', '健康检测', '/supervision/healthCheck');



  

  const RouteEnum(this.path, this.title, [this.fullpath]);

  final String path;
  final String title;
  final String? fullpath;

}