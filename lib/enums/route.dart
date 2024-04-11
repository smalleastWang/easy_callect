enum RouteEnum {

  home('/home', '首页', ''),
  login('/login', '登录'),


  insurance('/insurance', '智慧保险'),
  standardVerification('standardVerification', '验标注册', '/insurance/standardVerification'),



  finance('/finance', '养殖金融'),

  precisionBreeding('/precisionBreeding', '精准养殖'),

  supervision('/supervision', '行业监督'),

  inventory('/inventory', '盘点管理'),
  performance('/performance', '性能测定'),
  weight('/estimate-weight', '智能估重'),
  behavior('/behavior', '行为分析'),
  health('/health', '健康监测'),
  position('/position', '实时定位'),
  security('/security', '智能安防'),
  pen('/pen', '圈舍管理');

  const RouteEnum(this.path, this.title, [this.fullpath]);

  final String path;
  final String title;
  final String? fullpath;

}