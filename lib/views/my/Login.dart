

import 'package:dart_sm/dart_sm.dart';
import 'package:easy_collect/api/my.dart';
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/enums/StorageKey.dart';
import 'package:easy_collect/utils/storage.dart';
import 'package:flutter/material.dart';
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
      // 'password': sha1.convert(utf8.encode(_pwdController.text)).toString()
      'password': SM2.encrypt(_pwdController.text,'04298364ec840088475eae92a591e01284d1abefcda348b47eb324bb521bb03b0b2a5bc393f6b71dabb8f15c99a0050818b56b23f31743b93df9cf8948f15ddb54')
      });
    SharedPreferencesManager().setString(StorageKeyEnum.token.value, token);
    context.go(RouteEnum.home.value);
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // title: Text(AppLocalizations.of(context).login),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 60, bottom: 80),
                alignment: Alignment.center,
                child: const Image(
                  width: 200,
                  image: AssetImage("assets/images/logo01.png")
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: TextFormField(
                  autofocus: true,
                  controller: _unameController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 6),
                    border: OutlineInputBorder(),
                    hintText: '请输入您的账号',
                    prefixIcon: Icon(Icons.person)
                  ),
                  validator: (v) {
                    return v!.trim().isNotEmpty ? null : "账号不能为空";
                  },
                )
              ),
              TextFormField(
                controller: _pwdController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  border: const OutlineInputBorder(),
                  hintText: '请输入您的密码',
                  prefixIcon: const Icon(Icons.lock),
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
                padding: const EdgeInsets.only(top: 28.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('登录', style: TextStyle(fontSize: 18)),
                        ),
                        onPressed: () async {
                          // 通过_formKey.currentState 获取FormState后，
                          // 调用validate()方法校验用户名密码是否合法，校验
                          // 通过后再提交数据。
                          if ((_formKey.currentState as FormState).validate()) {
                            handlesSubmit();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}