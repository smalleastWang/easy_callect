import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/api/precisionBreeding.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:easy_collect/api/health.dart';
import 'package:easy_collect/widgets/List/ListItem.dart';
import 'package:easy_collect/enums/Route.dart';

class HealthPage extends ConsumerStatefulWidget {
  const HealthPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HealthPageState createState() => _HealthPageState();
}

class _HealthPageState extends ConsumerState<HealthPage> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<EnclosureModel>> weightInfoTree = ref.watch(weightInfoTreeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(RouteEnum.health.title),
      ),
      body: ListWidget<HealthPageFamily>(
       pasture: PastureModel(
          field: 'orgId',
          options: weightInfoTree.value ?? []
        ),
        provider: healthPageProvider,
        builder: (healthData) {
          return ListItemWidget(
            rowData: healthData,
            columns: [
              ListColumnModal(label: '牧场', field: 'orgName'),
              ListColumnModal(label: '牛耳标', field: 'no'),
              ListColumnModal(label: '唯一标识码', field: 'algorithmCode'),
              ListColumnModal(label: '健康监测类型', field: 'postureName'),
              ListColumnModal(label: '检测时间', field: 'createTime'),
            ],
          );
        },
      ),
    );
  }
}