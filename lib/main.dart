import 'package:easy_collect/api/message.dart';
import 'package:easy_collect/api/my.dart';
import 'package:easy_collect/enums/route.dart';
import 'package:easy_collect/models/PageVo.dart';
import 'package:easy_collect/models/message/JPushRegistration.dart';
import 'package:easy_collect/models/user/UserInfo.dart';
import 'package:easy_collect/router/index.dart';
import 'package:easy_collect/utils/colors.dart';
import 'package:easy_collect/utils/global.dart';
import 'package:easy_collect/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 初始化存储
  await SharedPreferencesManager().init();
  await DatabaseManager().init();
    
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {

  String? debugLable = 'Unknown';
  final JPush jpush = JPush();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }
  Future<void> initPlatformState() async {
    String? platformVersion;
    try {
      jpush.addEventHandler(
          onReceiveNotification: (Map<String, dynamic> message) async {
        print("flutter onReceiveNotification: $message");
        // 当收到新消息->更新新消息
        AsyncValue<PageVoModel> res = ref.refresh(newMessagePageProvider({
          'current': 0,
          'pages': 1,
          'size': 15,
        }));
        if (res.hasError) {
          print('Error: ${res.error}');
          throw Exception(res.error);
        }
        setState(() {
          debugLable = "flutter onReceiveNotification: $message";
        });
      }, onOpenNotification: (Map<String, dynamic> message) async {
        print("flutter onOpenNotification: $message");
        context.go(RouteEnum.home.path, extra: {'currentIndex': 0});
        setState(() {
          debugLable = "flutter onOpenNotification: $message";
        });
      }, onReceiveMessage: (Map<String, dynamic> message) async {
        print("flutter onReceiveMessage: $message");
        setState(() {
          debugLable = "flutter onReceiveMessage: $message";
        });
      }, onReceiveNotificationAuthorization:
              (Map<String, dynamic> message) async {
        print("flutter onReceiveNotificationAuthorization: $message");
        setState(() {
          debugLable = "flutter onReceiveNotificationAuthorization: $message";
        });
      }, onNotifyMessageUnShow: (Map<String, dynamic> message) async {
        print("flutter onNotifyMessageUnShow: $message");
        setState(() {
          debugLable = "flutter onNotifyMessageUnShow: $message";
        });
      }, onInAppMessageShow: (Map<String, dynamic> message) async {
        print("flutter onInAppMessageShow: $message");
        setState(() {
          debugLable = "flutter onInAppMessageShow: $message";
        });
      }, onCommandResult: (Map<String, dynamic> message) async {
        print("flutter onCommandResult: $message");
        setState(() {
          debugLable = "flutter onCommandResult: $message";
        });
      }, onInAppMessageClick: (Map<String, dynamic> message) async {
        print("flutter onInAppMessageClick: $message");
        setState(() {
          debugLable = "flutter onInAppMessageClick: $message";
        });
      }, onConnected: (Map<String, dynamic> message) async {
        print("flutter onConnected: $message");
        setState(() {
          debugLable = "flutter onConnected: $message";
        });
      });
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    jpush.setup(
      appKey: "8b15ec1ee4c0c28acfa9c6d8", //你自己应用的 AppKey
      // channel: "theChannel",
      production: false,
      debug: true,
    );
    jpush.setAuth(enable: true);
    jpush.applyPushAuthority(const NotificationSettingsIOS(sound: true, alert: true, badge: true));

    // Platform messages may fail, so we use a try/catch PlatformException.
    jpush.getRegistrationID().then((rid) async {
      final registrationDetail = await getRegistrationInfoApi(RegistrationModel(registrationId: rid));
      if (registrationDetail == null) {
        UserInfoModel userinfo = await MyApi.getUserInfoApi();
        await addRegistrationApi(RegistrationModel(
          registrationId: rid,
          orgId: userinfo.orgId
        ));
      }
      print("flutter get registration id : $rid");
      setState(() {
        debugLable = "flutter getRegistrationID: $rid";
      });
    });
    jpush.setChannelAndSound();

    // iOS要是使用应用内消息，请在页面进入离开的时候配置pageEnterTo 和  pageLeave 函数，参数为页面名。
    jpush.pageEnterTo("HomePage"); // 在离开页面的时候请调用 jpush.pageLeave("HomePage");

    if (!mounted) return;

    setState(() {
      debugLable = platformVersion;
    });
    // 通知权限
    PermissionStatus notificationStatus = await Permission.notification.status;
    if (notificationStatus.isDenied) {
      Permission.notification.request();
    }
  }
  
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