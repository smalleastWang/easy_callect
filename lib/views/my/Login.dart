import 'package:dart_sm/dart_sm.dart';
import 'package:easy_collect/api/my.dart';
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/enums/StorageKey.dart';
import 'package:easy_collect/utils/const.dart';
import 'package:easy_collect/utils/storage.dart';
import 'package:easy_collect/widgets/Button/BlockButton.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _unameController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final FocusNode _unameFocusNode = FocusNode();
  final FocusNode _pwdFocusNode = FocusNode();
  final GlobalKey _formKey = GlobalKey<FormState>();

  bool isShow = false;
  bool pwdVisible = false;
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    // _unameFocusNode.requestFocus();
    _loadSavedCredentials();  // 加载保存的用户名和密码

    /// WidgetsBinding 它能监听到第一帧绘制完成，第一帧绘制完成标志着已经Build完成
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ///获取输入框焦点
      FocusScope.of(context).requestFocus(_unameFocusNode);
    });

  }

  // 加载保存的用户名和密码
  _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _unameController.text = prefs.getString(StorageKeyEnum.username.value) ?? '';
      _pwdController.text = prefs.getString(StorageKeyEnum.password.value) ?? '';
      rememberMe = prefs.getBool(StorageKeyEnum.rememberMe.value) ?? false;
    });
  }

  handlesSubmit() async {
    String token = await MyApi.fetchLoginApi({
      'account': _unameController.text,
      'password': SM2.encrypt(_pwdController.text, sm2PublicKey)
    });

    // 保存token
    SharedPreferencesManager().setString(StorageKeyEnum.token.value, token);

    if (rememberMe) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(StorageKeyEnum.username.value, _unameController.text);
      prefs.setString(StorageKeyEnum.password.value, _pwdController.text);
      prefs.setBool(StorageKeyEnum.rememberMe.value, true);
    } else {
      _clearSavedCredentials();
    }

    context.replace(RouteEnum.home.path);
  }
  @override
  void dispose() {
    _unameFocusNode.dispose();
    _pwdFocusNode.dispose();
    super.dispose();
  }

  // 清除保存的用户名和密码
  _clearSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(StorageKeyEnum.username.value);
    prefs.remove(StorageKeyEnum.password.value);
    prefs.remove(StorageKeyEnum.rememberMe.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const Image(
              image: AssetImage("assets/images/login_bg.png")
            ),
            Transform.translate(
              offset: const Offset(0.0, -40.0),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.elliptical(36, 40),
                    topRight: Radius.elliptical(36, 40),
                  )
                ),
                padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('账号', style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Listener(
                        onPointerDown: (e) => FocusScope.of(context).requestFocus(_unameFocusNode),
                        child: TextFormField(
                          focusNode: _unameFocusNode,
                          controller: _unameController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 6),
                            // border: OutlineInputBorder(),
                            hintText: '请输入您的账号',
                          ),
                          validator: (v) {
                            return v!.trim().isNotEmpty ? null : "账号不能为空";
                          },
                        ),
                      )
                    ),
                    const Text('密码', style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)),
                    Listener(
                      onPointerDown: (e) => FocusScope.of(context).requestFocus(_pwdFocusNode),
                      child: TextFormField(
                        focusNode: _pwdFocusNode,
                        controller: _pwdController,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                          // border: const UnderlineInputBorder(),
                          hintText: '请输入您的密码',
                          suffixIcon: IconButton(
                            icon: Icon(pwdVisible ? Icons.visibility : Icons.visibility_off),
                            onPressed: () { 
                              setState(() {
                                pwdVisible = !pwdVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: !pwdVisible,
                        //校验密码
                        validator: (v) {
                          return v!.trim().length > 5 ? null : "密码不能少于6位";
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Transform.translate(
                          offset: const Offset(-14, 0),
                          child: Checkbox(
                            value: rememberMe,
                            onChanged: (value) {
                              setState(() {
                                rememberMe = value!;
                              });
                            },
                          ),
                        ),
                        const Text('记住密码'),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 70),
                      child: BlockButton(
                        onPressed: () async {
                          if ((_formKey.currentState as FormState).validate()) {
                            handlesSubmit();
                          }
                        },
                        text: '登录',
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}