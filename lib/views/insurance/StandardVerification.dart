
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/views/insurance/data.dart';
import 'package:easy_collect/widgets/Register/AreaPicker.dart';
import 'package:easy_collect/widgets/Register/RegisterType.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';


final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class StandardVerificationPage extends StatefulWidget {
  const StandardVerificationPage({super.key});

  @override
  State<StandardVerificationPage> createState() => _StandardVerificationPageState();
}

class _StandardVerificationPageState extends State<StandardVerificationPage> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey _formKey = GlobalKey<FormState>();
  final TextEditingController _numController = TextEditingController();
  List<String> penValue = [];

  int registerType = 1;
  int changeRegisterCnt = 1;

  @override
  void initState() {
    super.initState();
  }
  _changeRegisterType(value) {
    setState(() {
      registerType = value;
    });
  }

  _changeRegisterCnt(value) {
    setState(() {
      changeRegisterCnt = value;
    });
  }
  Widget get _getRegisterCnt {
    if (registerType == 1) {
      return RegisterTypeWidget<int>(options: singleOptions, onChange: _changeRegisterCnt);
    } else if (registerType == 2) {
      return RegisterTypeWidget<int>(options: multipleOptions, onChange: _changeRegisterCnt);
    }
    return const SizedBox.shrink();
  }

  void _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);
    print(pickedFile);
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(title: Text(RouteEnum.standardVerification.title)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _numController,
                  decoration: const InputDecoration(
                    labelText: '耳标号',
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 6),
                    border: OutlineInputBorder(),
                    hintText: '请输入牛耳耳标号(不支持中文)',
                  ),
                  validator: (v) {
                    return v!.trim().isNotEmpty ? null : "耳标号不能为空";
                  },
                ),
                AreaPickerWidget(
                  onChange: (value) {
                    setState(() {
                      penValue = value;
                    });
                  }
                ),
                RegisterTypeWidget<int>(defaultValue: registerType, options: registerTypeOptions, onChange: _changeRegisterType),
                _getRegisterCnt,
                ElevatedButton(
                  child: const  Text('选择图片'),
                  onPressed: () {
                    showCupertinoModalPopup<ImageSource>(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoActionSheet(
                          actions: [
                            CupertinoActionSheetAction(
                              onPressed: () => context.pop(ImageSource.gallery),
                              child: const Text("打开相册")
                            ),
                            CupertinoActionSheetAction(
                              onPressed: () => context.pop(ImageSource.camera),
                              child: const Text("拍摄")
                            )
                          ],
                          cancelButton: CupertinoActionSheetAction(
                            onPressed: () => context.pop(),
                            child: const Text("取消")
                          ),
                        );
                      }
                    ).then((source) {
                      if (source != null) {
                        _pickImage(source);
                      }
                    });
                  },
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}