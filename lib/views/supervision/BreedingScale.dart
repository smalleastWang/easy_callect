import 'package:easy_collect/api/precisionBreeding.dart';
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/widgets/List/ListItem.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BreedingScalePage extends ConsumerStatefulWidget {
  const BreedingScalePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BreedingScalePageState();
}

class _BreedingScalePageState extends ConsumerState<BreedingScalePage> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<EnclosureModel>> weightInfoTree = ref.watch(weightInfoTreeProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(RouteEnum.breedingScale.title),
      ),
      body: ListWidget<WeightInfoPageFamily>(
        pasture: PastureModel(
          field: 'orgId',
          options: weightInfoTree.value ?? []
        ),
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