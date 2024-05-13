import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/api/precisionBreeding.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:easy_collect/api/position.dart';
import 'package:easy_collect/widgets/List/ListItem.dart';
import 'package:easy_collect/enums/Route.dart';

class PositionPage extends ConsumerStatefulWidget {
  const PositionPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PositionPageState createState() => _PositionPageState();
}

class _PositionPageState extends ConsumerState<PositionPage> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<EnclosureModel>> weightInfoTree = ref.watch(weightInfoTreeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(RouteEnum.position.title),
      ),
      body: ListWidget<PositionPageFamily>(
       pasture: PastureModel(
          field: 'orgId',
          options: weightInfoTree.value ?? []
        ),
        provider: positionPageProvider,
        builder: (positionData) {
          return ListItemWidget(
            rowData: positionData,
            columns: [
              ListColumnModal(label: '牧场', field: 'orgName'),
              ListColumnModal(label: '圈舍名称', field: 'buildingName'),
              ListColumnModal(label: '牛耳标', field: 'animalNo'),
              ListColumnModal(label: '唯一标识码', field: 'algorithmCode'),
              ListColumnModal(label: '采集日期', field: 'inventoryDate'),
            ],
          );
        },
      ),
    );
  }
}