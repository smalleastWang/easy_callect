
import 'package:easy_collect/models/dropDownMenu/DropDownMenu.dart';
import 'package:easy_collect/utils/OverlayManager.dart';
import 'package:easy_collect/views/precisionBreeding/widgets/PastureVideo.dart';
import 'package:easy_collect/widgets/List/ListCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_collect/api/precisionBreeding.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/widgets/List/index.dart';
import 'package:easy_collect/api/security.dart';

class SecurityPage extends ConsumerStatefulWidget {
  const SecurityPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SecurityPageState();
}

class _SecurityPageState extends ConsumerState<SecurityPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    overlayEntryAllRemove();
    _tabController.dispose();
    super.dispose();
  }

  // 智能安防
  Widget get _securityList {
    final AsyncValue<List<EnclosureModel>> weightInfoTree = ref.watch(weightInfoTreeProvider);
    return Container(
      color: const Color(0xFFF1F5F9),
      child: Column(
        children: [
          Expanded(
            child: weightInfoTree.when(
              data: (data) {
                return ListWidget<SecurityPageFamily>(
                  pasture: PastureModel(
                    field: 'orgId',
                    options: data,
                  ),
                  provider: securityPageProvider,
                  filterList: [
                    DropDownMenuModel(name: '牛耳标', layerLink: LayerLink(), fieldName: 'no', widget: WidgetType.input),
                    DropDownMenuModel(name: '预警日期', layerLink: LayerLink(), fieldName: 'startDate,endDate', widget: WidgetType.dateRangePicker),
                  ],
                  builder: (rowData) {
                    return SecurityItem(rowData: rowData);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('加载数据时出错: $err')),
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('智能安防'),
        bottom: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: '智能安防'),
          Tab(text: '牧场视频'),
        ],
      ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _securityList,
          const PastureVideo(),
        ],
      )
      
    );
  }
}

class SecurityItem extends StatelessWidget {
  final Map<String, dynamic> rowData;

  const SecurityItem({super.key, required this.rowData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF5D8FFD),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                rowData["dataType"] ?? '未知',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              rowData["orgName"] ?? '未知',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
          ],
        ),
        ListCardCell(
          label: '设备唯一码',
          value: rowData["devId"],
        ),
        ListCardCell(
          label: '牛耳标',
          value: rowData["animalNo"],
        ),
        ListCardCellTime(
          label: '预警日期',
          value: rowData["date"],
        ),
      ],
    );
  }
}

