enum RouteEnum {

  home('/home', '首页'),
  login('/login', '登录');

  const RouteEnum(this.value, this.title);

  final String value;
  final String title;

}