import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:easy_collect/api/message.dart';
import 'package:easy_collect/api/my.dart';
import 'package:easy_collect/models/message/registration.dart';
import 'package:easy_collect/models/user/UserInfo.dart';
import 'package:easy_collect/router/index.dart';
import 'package:easy_collect/utils/colors.dart';
import 'package:easy_collect/utils/global.dart';
import 'package:easy_collect/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 初始化存储
  await SharedPreferencesManager().init();
  await DatabaseManager().init();
    
  runApp(const ProviderScope(
    child: MyApp(),
  ));

  JPush jpush = JPush();
  DeviceInfoPlugin infoPlugin = DeviceInfoPlugin();

  addRegistration(String deviceId) async {
    RegistrationModel? info = await getRegistrationInfoApi(RegistrationModel(registrationId: deviceId));
    if (info == null) {
      UserInfoModel userinfo = await MyApi.getUserInfoApi();
      await addRegistrationApi(RegistrationModel(
        registrationId: deviceId,
        orgId: userinfo.orgId
      ));
    }
  }
  if (Platform.isIOS) {
    
    IosDeviceInfo deviceInfo = await infoPlugin.iosInfo;
    await addRegistration(deviceInfo.toString());
    jpush.setup(
      // /biz/dev/add
      appKey: "8b15ec1ee4c0c28acfa9c6d8",
      // channel: "theChannel",
      production: false,
      debug: false, // 设置是否打印 debug 日志
    );
  } else if (Platform.isAndroid) {
    AndroidDeviceInfo deviceInfo = await infoPlugin.androidInfo;
    await addRegistration(deviceInfo.id);
    jpush.applyPushAuthority(const NotificationSettingsIOS(
      sound: true,
      alert: true,
      badge: true)
    );
  }
  
  jpush.addEventHandler(
    // 接收通知回调方法。
    onReceiveNotification: (Map<String, dynamic> message) async {
      print("flutter onReceiveNotification: $message");
    },
    // 点击通知回调方法。
    onOpenNotification: (Map<String, dynamic> message) async {
    print("flutter onOpenNotification: $message");
    },
    // 接收自定义消息回调方法。
    onReceiveMessage: (Map<String, dynamic> message) async {
    print("flutter onReceiveMessage: $message");
    },
    onConnected: (Map<String, dynamic> message) async {
    print("flutter onConnected: $message");
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '易采天成',
      theme:  ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: MyColors.primaryColor,
          primary: MyColors.primaryColor,
        ),
        useMaterial3: true,
      ),
      routerConfig: router,
      builder: EasyLoading.init(),
      // 设置本地化属性
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale.fromSubtags(languageCode: 'zh'),
        // Locale('zh', 'CN'), // 设置为中国大陆的简体中文
      ],
    );
  }
}
