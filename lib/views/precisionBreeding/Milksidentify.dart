import 'package:easy_collect/api/precisionBreeding.dart';
import 'package:easy_collect/enums/route.dart';
import 'package:easy_collect/models/dropDownMenu/DropDownMenu.dart';
import 'package:easy_collect/utils/OverlayManager.dart';
import 'package:easy_collect/widgets/Button/PrimaryActionButton.dart';
import 'package:easy_collect/widgets/List/ListCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:easy_collect/api/milksidentify.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';

class MilksidentifyPage extends ConsumerStatefulWidget {
  const MilksidentifyPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MilksidentifyPageState();
}

class _MilksidentifyPageState extends ConsumerState<MilksidentifyPage> {
  final GlobalKey<ListWidgetState> listWidgetKey = GlobalKey<ListWidgetState>();

  @override
  void dispose() {
    overlayEntryAllRemove();
    super.dispose();
  }

  void _navigateTo(String path, [Map<String, dynamic>? rowData]) async {
    bool? result = await context.push(path, extra: rowData);
    // 如果返回结果为true，则刷新列表
    if (result == true) {
      listWidgetKey.currentState?.refreshWithPreviousParams();
    }
  }

  void _editMilksidentify([Map<String, dynamic>? rowData]) {
    _navigateTo(RouteEnum.editMilksidentify.path, rowData);
  }
  
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<EnclosureModel>> weightInfoTree =
        ref.watch(weightInfoTreeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('在位识别'),
         actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _editMilksidentify,
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFFF1F5F9),
        // padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            Expanded(
              child: weightInfoTree.when(
                data: (data) => buildListWidget(data),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('加载数据时出错: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListWidget(List<EnclosureModel> data) {
    return ListWidget<MilksidentifyPageFamily>(
      pasture: PastureModel(
        field: 'orgId',
        options: data,
      ),
      key: listWidgetKey,
      provider: milksidentifyPageProvider,
      filterList: [
        DropDownMenuModel(name: '牛耳标', layerLink: LayerLink(), fieldName: 'no', widget: WidgetType.input),
        DropDownMenuModel(name: '奶位号', layerLink: LayerLink(), fieldName: 'milkPos', widget: WidgetType.input),
        DropDownMenuModel(name: '预警日期', layerLink: LayerLink(), fieldName: 'startDate,endDate', widget: WidgetType.dateRangePicker),
      ],
      builder: (milksidentifyData) {
        return MilksidentifyItem(rowData: milksidentifyData, onEdit: _editMilksidentify);
      },
    );
  }
}

class MilksidentifyItem extends StatelessWidget {
  final Map<String, dynamic> rowData;
  final Function(Map<String, dynamic>) onEdit;

  const MilksidentifyItem({super.key, required this.rowData, required this.onEdit});

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Image",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                Center(
                  child: PhotoView(
                    imageProvider: NetworkImage(imageUrl),
                    backgroundDecoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 2,
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 20,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 24,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListCardCell(
          label: '挤奶位编号',
          value: rowData["milkPos"],
        ),
        // ListCardCell(
        //   label: '牧场',
        //   value: rowData["orgName"],
        // ),
        ListCardCell(
          label: '耳标号',
          value: rowData["no"],
        ),
        ListCardCell(
          label: '轮次',
          value: rowData["wave"],
        ),
        ListCardCell(
          label: '挤奶量',
          value: rowData["milkAmount"],
        ),
        // ListCardCell(
        //   label: '设备唯一码',
        //   value: rowData["algorithmCode"],
        // ),
        ListCardCell(
          label: '识别时间',
          value: rowData["identifyTime"],
        ),
        // ListCardCellTime(
        //   label: '识别时间',
        //   value: rowData["identifyTime"],
        // ),
        const SizedBox(height: 12),
        const Divider(height: 0.5, color: Color(0xFFE2E2E2)),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            PrimaryActionButton(
              text: '修改',
              onPressed: () => onEdit(rowData),
            ),
            const SizedBox(width: 10),
            OutlineActionButton(
              text: '详情',
              onPressed: () => _showFullScreenImage(context, rowData["img"]),
            ),
          ],
        )
      ],
    );
  }
}