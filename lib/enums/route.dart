enum RouteEnum {

  home('/', '首页'),
  cameraRegister('/cameraRegister', '首页'),
  login('/login', '登录'),
  userInfo('/userInfo', '用户基本信息'),


  // 智慧保险
  insurance('/insurance', '智慧保险'),
  standardVerification('standardVerification', '验标注册', '/insurance/standardVerification'),
  surveyCompared('surveyCompared', '查勘对比', '/insurance/surveyCompared'),



  // 养殖金融
  finance('/finance', '养殖金融'),


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
  supervision('/supervision', '行业监督');



  

  const RouteEnum(this.path, this.title, [this.fullpath]);

  final String path;
  final String title;
  final String? fullpath;

}