# easy_collect
易采天成项目

### 生成model文件命令
```shell
flutter packages pub run build_runner build
```

### 运行
```shell
flutter run --dart-define=APP_ENV=DEV
```

### 打包
Android
```shell
flutter build apk --dart-define=APP_ENV=PRO
```
IOS
```shell
flutter build ios --dart-define=APP_ENV=PRO
```