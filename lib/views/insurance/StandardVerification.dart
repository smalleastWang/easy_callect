import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/models/common/Area.dart';
import 'package:easy_collect/models/common/Option.dart';
import 'package:easy_collect/views/insurance/data.dart';
import 'package:easy_collect/widgets/Register/AreaPicker.dart';
import 'package:easy_collect/widgets/Register/RegisterType.dart';
import 'package:flutter/material.dart';


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
  List<AreaModel> areaList = [];

  @override
  void initState() {
    super.initState();
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
                // RegisterTypeWidget(options: registerTypeOptions),
                
                // RegisterTypeWidget(options: singleOptions),
                // RegisterTypeWidget(options: multipleOptions),
              ],
            ),
          ),
        ),
      )
    );
  }
}