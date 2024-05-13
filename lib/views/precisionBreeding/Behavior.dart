import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/api/precisionBreeding.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:easy_collect/api/behavior.dart';
import 'package:easy_collect/widgets/List/ListItem.dart';

class BehaviorPage extends ConsumerStatefulWidget {
  const BehaviorPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BehaviorPageState createState() => _BehaviorPageState();
}

class _BehaviorPageState extends ConsumerState<BehaviorPage> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<EnclosureModel>> weightInfoTree = ref.watch(weightInfoTreeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('行为分析'),
      ),
      body: ListWidget<BehaviorPageFamily>(
       pasture: PastureModel(
          field: 'orgId',
          options: weightInfoTree.value ?? []
        ),
        provider: behaviorPageProvider,
        builder: (behaviorData) {
          return ListItemWidget(
            rowData: behaviorData,
            columns: [
              ListColumnModal(label: '牧场', field: 'orgName'),
              ListColumnModal(label: '牛耳标', field: 'no'),
              ListColumnModal(label: '唯一标识码', field: 'algorithmCode'),
              ListColumnModal(label: '行为类型', field: 'postureName'),
              ListColumnModal(label: '数量', field: 'times'),
              ListColumnModal(label: '检测时间', field: 'createTime'),
            ],
          );
        },
      ),
    );
  }
}