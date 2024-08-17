enum RouteEnum {

  home('/', '首页', '/'),
  cameraRegister('/cameraRegister', '首页', '/cameraRegister'),
  login('/login', '登录', '/login'),
  downLoad('/downLoad', '资料下载', '/downLoad'),
  userInfo('/userInfo', '用户基本信息', '/userInfo'),
  comboList('/comboList', '套餐信息', '/comboList'),
  comboDetail('/comboDetail', '套餐详情', '/comboDetail'),
  billList('/billList', '账单列表', '/billList'),
  billDetail('/billDetail', '账单详情', '/billDetail'),
  packageScreen('/packageScreen', '已购套餐信息', '/packageScreen'),
  editBuilding('/editBuilding', '添加圈舍信息', '/editBuilding'),
  performanceDetail('/performanceDetail', '体征详情', '/performanceDetail'),
  editAiBox('/editAiBox', '添加AI盒子', '/editAiBox'),

  // 智慧保险
  insurance('/insurance', '智慧保险', '/insurance'),
  standardVerification('standardVerification', '验标注册', '/insurance/standardVerification'),
  surveyCompared('surveyCompared', '查勘对比', '/insurance/surveyCompared'),
  orderList('orderList', '保单信息', '/insurance/orderList'),
  editPolicy('/editPolicy', '添加保单', '/editPolicy'),
  insuranceDetail('/insuranceDetail', '保单详情', '/insuranceDetail'),
  insuranceDetailAdd('/insuranceDetailAdd', '保单绑定', '/insuranceDetailAdd'),
  animalSelect('animalSelect', '选择牛只', '/common/animalSelect'),
  insuranceApplicant('insuranceApplicant', '投保人信息', '/insurance/insuranceApplicant'),
  editInsuranceApplicant('/editInsuranceApplicant', '添加投保人', '/editInsuranceApplicant'),
  countRegister('countRegister', '计数盘点', '/insurance/countRegister'),

  // 养殖金融
  finance('/finance', '养殖金融', '/finance'),
  cattleRegiter('cattleRegiter', '牛只注册','/finance/cattleRegiter'),
  financeCount('financeCount', '计数盘点','/finance/financeCount'),
  cattleDiscern('cattleDiscern', '牛只识别','/finance/cattleDiscern'),
  financeVideo('financeVideo', '实时视频','/finance/financeVideo'),

  // 精准养殖
  precisionBreeding('/precisionBreeding', '精准养殖', '/precisionBreeding'),
  inventory('inventory', '盘点管理', '/precisionBreeding/inventory'),
  inventorySetTime('setTime', '设置盘点时间', '/precisionBreeding/inventory/setTime'),
  inventorySetUploadTime('setUploadTime', '设置上传时间', '/precisionBreeding/inventory/setUploadTime'),
  inventoryHistoryData('historyData', '历史数据', '/precisionBreeding/inventory/historyData'),
  performance('performance', '性能测定', '/precisionBreeding/performance'),
  weight('weight', '智能估重', '/precisionBreeding/weight'),
  behavior('behavior', '行为分析', '/precisionBreeding/behavior'),
  health('health', '健康监测', '/precisionBreeding/health'),
  intelligencewarn('intelligencewarn', '智能预警', '/precisionBreeding/intelligencewarn'),
  position('position', '实时定位', '/precisionBreeding/position'),
  security('security', '安防报警', '/precisionBreeding/security'),
  pen('pen', '圈舍管理', '/precisionBreeding/pen'),
  milksidentify('milksidentify', '在位识别', '/precisionBreeding/milksidentify'),

  // 行业监督
  supervision('/supervision', '行业监督', '/supervision'),
  breedingScale('breedingScale', '养殖规模', '/supervision/breedingScale'),
  mortgageInfo('mortgageInfo', '抵押信息', '/supervision/mortgageInfo'),
  insureInfo('insureInfo', '投保信息', '/supervision/insureInfo'),
  healthInfo('healthInfo', '健康信息', '/supervision/healthInfo'),

  common('/common', '管理员设置', '/common'),
  aibox('aibox', 'AI盒子', '/common/aibox'),
  building('building', '圈舍信息', '/common/building'),
  camera('camera', '摄像头管理', '/common/camera'),
  animal('animal', '牛只信息', '/common/animal'),
  pigAnimal('pigAnimal', '猪信息', '/common/pigAnimal'),
  email('email', '邮箱管理', '/common/email'),
  registerRecord('registerRecord', '牛注册记录', '/common/registerRecord'),
  distinguishRecord('distinguishRecord', '牛识别记录', '/common/distinguishRecord'),
  registerPigRecord('registerPigRecord', '猪注册记录', '/common/registerPigRecord'),
  distinguishPigRecord('distinguishPigRecord', '猪识别记录', '/common/distinguishPigRecord');


  const RouteEnum(this.path, this.title, this.fullpath);

  final String path;
  final String title;
  final String fullpath;

}