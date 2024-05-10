# easy_collect
易采天成项目

### 生成model文件命令
```shell
flutter packages pub run build_runner build
```
或
```shell
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 运行
```shell
flutter run --dart-define=APP_ENV=DEV
```

### 打包
Android
```shell
flutter build apk --dart-define=APP_ENV=DEV
flutter build apk --dart-define=APP_ENV=PROD
```
IOS
```shell
flutter build ios --dart-define=APP_ENV=DEV
flutter build ios --dart-define=APP_ENV=PROD
```


### context.go报错
在当前文件导入 go_router
```dart
import 'package:go_router/go_router.dart';
```

### 添加页面路由
- 在 /emums/Route.dart 下添加路由名
- 在 /Router/routes.dart 添加路由
- 页面跳转 context.go(RouteEnum.home.path)
- 无 context 情况 routeKey.currentContext!.go(RouteEnum.home.path)





账号：zdcd
密码：123456