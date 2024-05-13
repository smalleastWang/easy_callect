import 'package:easy_collect/api/precisionBreeding.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_collect/api/weight.dart';
import 'package:easy_collect/widgets/List/ListItem.dart';

class WeightPage extends ConsumerStatefulWidget {
  const WeightPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WeightPageState createState() => _WeightPageState();
}

class _WeightPageState extends ConsumerState<WeightPage> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<EnclosureModel>> weightInfoTree = ref.watch(weightInfoTreeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('体重信息'),
      ),
      body: ListWidget<WeightPageFamily>(
        pasture: PastureModel(
          field: 'orgId',
          options: weightInfoTree.value ?? []
        ),
        provider: weightPageProvider,
        builder: (data) {
          return ListItemWidget(
            rowData: data,
            columns: [
              ListColumnModal(label: '牧场', field: 'orgName'),
              ListColumnModal(label: '牛耳标', field: 'animalNo'),
              ListColumnModal(label: '唯一标识码', field: 'algorithmCode'),
              ListColumnModal(label: '估计体重', field: 'dataValue'),
              ListColumnModal(label: '测定日期', field: 'date'),
              ListColumnModal(
                  label: '与上一次的体重变化值', field: 'changeWeight'),
              ListColumnModal(label: '间隔天数', field: 'intervalDays'),
              ListColumnModal(label: '日增重', field: 'dailyGain'),
            ],
          );
        },
      ),
    );
  }
}
