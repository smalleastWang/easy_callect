import 'package:easy_collect/enums/index.dart';
import 'package:easy_collect/models/dropDownMenu/DropDownMenu.dart';
import 'package:easy_collect/utils/OverlayManager.dart';
import 'package:easy_collect/views/precisionBreeding/data.dart';
import 'package:easy_collect/widgets/List/ListCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/api/precisionBreeding.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:easy_collect/api/camera.dart';

class CameraPage extends ConsumerStatefulWidget {
  const CameraPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CameraPageState();
}

class _CameraPageState extends ConsumerState<CameraPage> {
  @override
  void dispose() {
    overlayEntryAllRemove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<EnclosureModel>> weightInfoTree = ref.watch(weightInfoTreeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('摄像头'),
      ),
      body: Container(
        color: const Color(0xFFF1F5F9),
        child: Column(
          children: [
            Expanded(
              child: weightInfoTree.when(
                data: (data) {
                  return ListWidget<CameraPageFamily>(
                    pasture: PastureModel(
                      field: 'orgId',
                      options: data,
                    ),
                    provider: cameraPageProvider,
                    filterList: [
                      DropDownMenuModel(name: '圈舍名称', layerLink: LayerLink(), fieldName: 'buildingName', widget: WidgetType.input),
                      DropDownMenuModel(name: '设备编号', layerLink: LayerLink(), fieldName: 'easyCvrId', widget: WidgetType.input),
                      DropDownMenuModel(name: '在线状态', list:  enumsStrValToOptions(OnlineStatusEnum.values, true, false), layerLink: LayerLink(), fieldName: 'online'),
                    ],
                    builder: (rowData) {
                      return CameraItem(rowData: rowData);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('加载数据时出错: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CameraItem extends StatelessWidget {
  final Map<String, dynamic> rowData;

  const CameraItem({super.key, required this.rowData});

  @override
  Widget build(BuildContext context) {
    String onlineStatus = rowData["state"] == "0" ? "在线" : "离线";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: rowData["state"] == "0" ? const Color(0xFF5D8FFD) : const Color(0xFFCCCCCC),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                onlineStatus,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              rowData["name"],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
          ],
        ),
        ListCardCell(
          label: '设备编号',
          value: rowData["boxNo"],
        ),
        ListCardCell(
          label: '牧场',
          value: rowData["orgName"],
        ),
        ListCardCell(
          label: '圈舍',
          value: rowData["buildingName"],
        ),
        ListCardCellTime(
          label: '创建时间',
          value: rowData["createTime"],
        ),
      ],
    );
  }
}