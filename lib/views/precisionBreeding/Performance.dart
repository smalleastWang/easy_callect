import 'package:easy_collect/api/common.dart';
import 'package:easy_collect/api/inventory.dart';
import 'package:easy_collect/api/precisionBreeding.dart';
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/models/PageVo.dart';
import 'package:easy_collect/models/dict/Dict.dart';
import 'package:easy_collect/models/dropDownMenu/DropDownMenu.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/utils/tool/dict.dart';
import 'package:easy_collect/widgets/DropDownMenu/index.dart';
import 'package:easy_collect/widgets/List/ListItem.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:easy_collect/widgets/LoadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ModuleListModel {
  RouteEnum route;
  Color background;
  ModuleListModel({required this.route, required this.background});
}

class PerformancePage extends ConsumerStatefulWidget {
  const PerformancePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PerformancePageState();
}

class _PerformancePageState extends ConsumerState<PerformancePage> {
  final List moduleList = [
    ModuleListModel(route: RouteEnum.inventory, background: Colors.black),
    ModuleListModel(route: RouteEnum.performance, background: Colors.black),
    ModuleListModel(route: RouteEnum.weight, background: Colors.black),
    ModuleListModel(route: RouteEnum.health, background: Colors.black),
    ModuleListModel(route: RouteEnum.position, background: Colors.black),
    ModuleListModel(route: RouteEnum.security, background: Colors.black),
    ModuleListModel(route: RouteEnum.pen, background: Colors.black),
  ];
  @override
  Widget build(BuildContext context) {
    // final AsyncValue<PageVoModel> weightInfoList = ref.watch(weightInfoPageProvider({}));
    final AsyncValue<List<EnclosureModel>> weightInfoTree = ref.watch(weightInfoTreeProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('体征信息'),
      ),
      body: ListWidget<WeightInfoPageFamily>(
        pasture: PastureModel(
          field: 'orgId',
          options: weightInfoTree.value ?? []
        ),
        // filterList: [
        //   getDictOptionsByValue(value, 'GENDER', 'gender'),
        //   getDictOptionsByValue(value, 'BRAND', 'brand'),
        // ].map((item) => DropDownMenuModel(
        //   fieldName: item.fieldName!,
        //   name: item.name ?? '',
        //   layerLink: LayerLink(),
        //   list: item.children?.map((e) => Option(check: false, dictLabel: e.dictLabel, dictValue: e.dictValue)).toList() ?? []
        // )).toList(),
        provider: weightInfoPageProvider,
        builder: (data) {
        
          return ListItemWidget(
            rowData: data,
            columns: [
              ListColumnModal(label: '牧场', field: 'orgName'),
              ListColumnModal(label: '圈舍', field: 'buildingName'),
              ListColumnModal(label: '牛耳标', field: 'animalNo'),
              ListColumnModal(label: '身长/CM', field: 'length'),
              ListColumnModal(label: '身高/CM', field: 'high'),
              ListColumnModal(label: '肩宽/CM', field: 'width'),
              ListColumnModal(label: '十字部高/CM', field: 'crossHigh'),
              ListColumnModal(label: '体斜长/CM', field: 'plag'),
              ListColumnModal(label: '胸围/CM', field: 'bust'),
              ListColumnModal(label: '腹围/CM', field: 'circum'),
              ListColumnModal(label: '管围/CM', field: 'canno'),
              ListColumnModal(label: '测定日期', field: 'date'),
            ]
          );
        },
      )
    );
  }
}