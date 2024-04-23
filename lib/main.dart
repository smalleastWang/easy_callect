import 'package:easy_collect/router/index.dart';
import 'package:easy_collect/utils/camera/DetectFFI.dart';
import 'package:easy_collect/utils/global.dart';
import 'package:easy_collect/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 初始化存储
  await SharedPreferencesManager().init();
  await DatabaseManager().init();
  final detFFIRes = await DetFFI.getInstance().init();
  if(!detFFIRes) {
    // EasyLoading.showToast('初始化失败');
    print('初始化失败');
  } else {
    print('初始化成功');
    // EasyLoading.showToast('初始化成功');
  }
    
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '易采天成',
      theme:  ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router,
      builder: EasyLoading.init(),
      // 设置本地化属性
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh', 'CN'), // 设置为中国大陆的简体中文
      ],
    );
  }
}
