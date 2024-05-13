import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/api/precisionBreeding.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:easy_collect/api/intelligencewarn.dart';
import 'package:easy_collect/widgets/List/ListItem.dart';
import 'package:easy_collect/enums/Route.dart';

class IntelligencewarnPage extends ConsumerStatefulWidget {
  const IntelligencewarnPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _IntelligencewarnPageState createState() => _IntelligencewarnPageState();
}

class _IntelligencewarnPageState extends ConsumerState<IntelligencewarnPage> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<EnclosureModel>> weightInfoTree = ref.watch(weightInfoTreeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(RouteEnum.intelligencewarn.title),
      ),
      body: ListWidget<IntelligencewarnPageFamily>(
       pasture: PastureModel(
          field: 'orgId',
          options: weightInfoTree.value ?? []
        ),
        provider: intelligencewarnPageProvider,
        builder: (intelligencewarnData) {
          return ListItemWidget(
            rowData: intelligencewarnData,
            columns: [
              ListColumnModal(label: '牧场', field: 'orgName'),
              ListColumnModal(label: '牛耳标', field: 'no'),
              ListColumnModal(label: '唯一标识码', field: 'algorithmCode'),
              ListColumnModal(label: '预警类型', field: 'warnTypeName'),
              ListColumnModal(label: '预警时间', field: 'createTime'),
            ],
          );
        },
      ),
    );
  }
}