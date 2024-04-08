import 'package:easy_collect/api/common.dart';
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/models/common/Area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

class StandardVerificationPage extends StatefulWidget {
  const StandardVerificationPage({super.key});

  @override
  State<StandardVerificationPage> createState() => _StandardVerificationPageState();
}

class _StandardVerificationPageState extends State<StandardVerificationPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey _formKey = GlobalKey<FormState>();
  final TextEditingController _numController = TextEditingController();
  List<String> penValue = [];
  List<AreaModel> areaList = [];

  @override
  void initState() {
    getAreaData();
    super.initState();
  }
  getAreaData() async{
    List<AreaModel> res = await CommonApi.getAreaApi();
    setState(() {
      areaList = res;
    });
  }

  String getName() {
    List<AreaModel> data = areaList.map((e) => e).toList();
    return penValue.map((e) {
      AreaModel item = data.firstWhere((element) => element.id == e);
      if (item.children != null) data = item.children!.map((e) => e).toList();
      return item.name;
    }).join('/');
  }

  List<PickerItem<String>> getPickerData(List<AreaModel> data) {
    return data.map((AreaModel e) {
      return PickerItem<String>(
        text: Text(e.name),
        value: e.id,
        children: getPickerData(e.children ?? [])
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text(RouteEnum.standardVerification.title)),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
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
              GestureDetector(
                onTap: () {
                   Picker picker = Picker(
                    height: 300,
                    confirmText: '确定',
                    cancelText: '取消',
                    adapter: PickerDataAdapter(
                      data: getPickerData(areaList), 
                    ),
                    changeToFirst: true,
                    textAlign: TextAlign.left,
                    columnPadding: const EdgeInsets.all(0),
                    onConfirm: (Picker picker, List value) {
                      print(value.toString());
                      print(picker.getSelectedValues());
                      setState(() {
                        penValue = picker.getSelectedValues().cast<String>();
                      });
                    }
                  );
                  picker.show(_scaffoldKey.currentState!);
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(vertical:10, horizontal: 6),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color.fromARGB(255, 126, 126, 126), width: 1),
                    borderRadius: BorderRadius.circular(4)
                  ),
                  child: Text(penValue.isNotEmpty ? getName() : '选择牧场、圈舍', style: const TextStyle(fontSize: 16)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}