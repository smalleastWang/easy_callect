import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/api/precisionBreeding.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:easy_collect/api/milksidentify.dart';
import 'package:easy_collect/widgets/List/ListItem.dart';
import 'package:easy_collect/enums/Route.dart';

class MilksidentifyPage extends ConsumerStatefulWidget {
  const MilksidentifyPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MilksidentifyPageState createState() => _MilksidentifyPageState();
}

class _MilksidentifyPageState extends ConsumerState<MilksidentifyPage> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<EnclosureModel>> weightInfoTree = ref.watch(weightInfoTreeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(RouteEnum.milksidentify.title),
      ),
      body: ListWidget<MilksidentifyPageFamily>(
       pasture: PastureModel(
          field: 'orgId',
          options: weightInfoTree.value ?? []
        ),
        provider: milksidentifyPageProvider,
        builder: (milksidentifyData) {
          return ListItemWidget(
            rowData: milksidentifyData,
            columns: [
              ListColumnModal(label: '牧场', field: 'orgName'),
              ListColumnModal(label: '挤奶位编号', field: 'milkPos'),
              ListColumnModal(label: '耳标号', field: 'no'),
              ListColumnModal(label: '轮次', field: 'wave'),
              ListColumnModal(label: '挤奶量', field: 'milkPos'),
              ListColumnModal(label: '设备唯一码', field: 'algorithmCode'),
              ListColumnModal(label: '识别时间', field: 'identifyTime'),
            ],
          );
        },
      ),
    );
  }
}