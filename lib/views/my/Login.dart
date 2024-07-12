

import 'package:dart_sm/dart_sm.dart';
import 'package:easy_collect/api/my.dart';
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/enums/StorageKey.dart';
import 'package:easy_collect/utils/const.dart';
import 'package:easy_collect/utils/storage.dart';
import 'package:easy_collect/widgets/Button/BlockButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _unameController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();

  bool isShow = false;
  bool pwdVisible = false;

  @override
  void initState() {
    super.initState();
  }
  
  handlesSubmit() async {
    SharedPreferencesManager();
    String token = await MyApi.fetchLoginApi({
      'account': _unameController.text,
      'password': SM2.encrypt(_pwdController.text, sm2PublicKey)
    });
    SharedPreferencesManager().setString(StorageKeyEnum.token.value, token);
    context.replace(RouteEnum.home.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   // title: Text(AppLocalizations.of(context).login),
      // ),
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
                      child: TextFormField(
                        autofocus: true,
                        controller: _unameController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 6),
                          // border: OutlineInputBorder(),
                          hintText: '请输入您的账号',
                        ),
                        validator: (v) {
                          return v!.trim().isNotEmpty ? null : "账号不能为空";
                        },
                      )
                    ),
                  const Text('密码', style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)),
                    TextFormField(
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
                    // 登录按钮
                    Padding(
                      padding: const EdgeInsets.only(top: 70),
                      child: BlockButton(
                        onPressed: () async {
                          // 通过_formKey.currentState 获取FormState后，
                          // 调用validate()方法校验用户名密码是否合法，校验
                          // 通过后再提交数据。
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

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}