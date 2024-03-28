enum RouteEnum {

  home('/home', '首页');

  const RouteEnum(this.value, this.title);

  final String value;
  final String title;

  // static Route getTypeByTitle(String title) => Route.values.firstWhere((activity) => activity.name == title);

  // static String getValue(String path) => Route.values.firstWhere((activity) => activity.value == value).value;

}