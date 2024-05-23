import 'package:json_annotation/json_annotation.dart';

part 'animal.g.dart';

@JsonSerializable()
class Animal {
  // 主键
  String? id;
  // 牧场
  String? orgId;
  // 圈舍
  String? buildingId;
  // 算法生成的唯一标识码
  String? algorithmCode;
  // 牛耳标
  String? no;
  // 授权状态（0未授权1已授权2过期3取消授权）
  String? pastureAuth;
  // 授权状态（0未授权1已授权2过期3取消授权）
  String? bankAuth;
  // 抵押状态（0未抵押1已抵押）
  String? mortgage;
  // 种类（输入）
  String? type;
  // 公母
  String? sex;
  // 健康状态
  String? health;
  // 身高
  String? high;
  // 体长
  String? length;
  // 步数
  String? step;
  // 重量
  String? weight;
  // 肩宽
  String? width;
  // 十字部高
  String? crossHigh;
  // 体斜长
  String? plag;
  // 胸围
  String? bust;
  // 腹围
  String? circum;
  // 管围
  String? canno;
  // 牧场授权开始
  String? bankAuthStart;
  // 牧场授权截至
  String? bankAuthEnd;
  // 金融机构授权开始
  String? pastureAuthStart;
  // 金融机构授权截至
  String? pastureAuthEnd;
  // 抵押金融机构
  String? mortOrg;
  // 抵押到期时间
  String? mortEnd;
  // 所属栋
  String? block;
  // 所属栏
  String? hurdle;
  // 备注
  String? comment;
  // 创建时间
  String? createTime;
  // 创建人
  String? createUser;
  // 修改时间
  String? updateTime;
  // 修改人
  String? updateUser;
  // 状态（0可用1禁用；2手机端与摄像头重复，标为不可用；3:盘点牛只丢失，4手机端注册中;5:出栏；6：死亡；7：预注册;8:预注册已合并）
  String? state;
  // 生长周期（数据字典）
  String? growth;
  // 繁殖状态（数据字典）
  String? breed;
  // 省
  String? province;
  // 牛只来源。0：正常注册；1：盘点注册；2其他
  int? source;
  // 注册来源0：摄像头端；1:手机端；2其他；3:无人机
  int? registerType;
  // 绑定的牛算法标识
  String? bindAlgorithmCode;
  // 牛姿态
  String? posture;
  // 存栏状态
  String? fieldState;
  // 抵押开始时间
  String? mortStart;
  // 组织名称
  String? orgName;
  // 圈舍
  String? buildName;
  // 牛图片
  List<String>? imgs;
  // 保险合同号
  String? policyNo;
  // 牛图片地址对象
  List<Image>? imgUrl;
  // 状态（0,正常,1删除）
  String? finalState;
  // 最终唯一码
  String? finalCode;
  // 照片类型0:牛身；1：牛脸
  String? imgType;

  Animal({
    this.id,
    this.orgId,
    this.buildingId,
    this.algorithmCode,
    this.no,
    this.pastureAuth,
    this.bankAuth,
    this.mortgage,
    this.type,
    this.sex,
    this.health,
    this.high,
    this.length,
    this.step,
    this.weight,
    this.width,
    this.crossHigh,
    this.plag,
    this.bust,
    this.circum,
    this.canno,
    this.bankAuthStart,
    this.bankAuthEnd,
    this.pastureAuthStart,
    this.pastureAuthEnd,
    this.mortOrg,
    this.mortEnd,
    this.block,
    this.hurdle,
    this.comment,
    this.createTime,
    this.createUser,
    this.updateTime,
    this.updateUser,
    this.state,
    this.growth,
    this.breed,
    this.province,
    this.source,
    this.registerType,
    this.bindAlgorithmCode,
    this.posture,
    this.fieldState,
    this.mortStart,
    this.orgName,
    this.buildName,
    this.imgs,
    this.policyNo,
    this.imgUrl,
    this.finalState,
    this.finalCode,
    this.imgType,
  });

  factory Animal.fromJson(Map<String, dynamic> json) => _$AnimalFromJson(json);

  Map<String, dynamic> toJson() => _$AnimalToJson(this);
}

@JsonSerializable()
class Image {
  // 主键
  String? id;
  // 创建时间
  String? createTime;
  // 创建人
  String? createUser;
  // 修改时间
  String? updateTime;
  // 修改人
  String? updateUser;
  // 状态（0,正常,1删除）
  String? state;
  // 算法生成的牛唯一标识码
  String? algorithmCode;
  // 牛图片地址
  String? imgUrl;
  // 最终唯一码
  String? finalCode;
  // 照片类型0:牛身；1：牛脸
  String? imgType;

  Image({
    this.id,
    this.createTime,
    this.createUser,
    this.updateTime,
    this.updateUser,
    this.state,
    this.algorithmCode,
    this.imgUrl,
    this.finalCode,
    this.imgType,
  });

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);

  Map<String, dynamic> toJson() => _$ImageToJson(this);
}
