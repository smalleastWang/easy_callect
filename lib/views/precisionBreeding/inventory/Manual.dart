import 'package:easy_collect/api/common.dart';
import 'package:easy_collect/api/precisionBreeding.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/widgets/List/PickerPastureWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_collect/widgets/List/index.dart';

class ManualPage extends ConsumerStatefulWidget {
  const ManualPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ManualPageState();
}

class _ManualPageState extends ConsumerState<ManualPage> {
  final GlobalKey<ListWidgetState> listWidgetKey = GlobalKey<ListWidgetState>();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusSearchInputNode = FocusNode();
  AsyncValue<List<dynamic>> dataList = const AsyncValue.loading();

  Map<String, dynamic> _createRequestParams() {
    return {};
  }

  void _onSearch() {
    _fetchList();
  }

  void _fetchList() {
    final provider = buildingTreeOnlineProvider(_createRequestParams());
    ref.read(provider.future).then((data) {
      if (mounted) {
        setState(() {
          dataList = AsyncValue.data(data);
        });
      }
    }).catchError((error) {
      print('Error fetching data list: $error');
    });
  }


  @override
  void initState() {
    super.initState();
     _fetchList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

 @override
  Widget build(BuildContext context) {
    final AsyncValue<List<EnclosureModel>> weightInfoTree =
        ref.watch(weightInfoTreeProvider);
    String selectedPasture = ''; // 保存当前选择的牧场ID

    return Scaffold(
      appBar: AppBar(
        title: const Text('手工盘点'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          _focusSearchInputNode.unfocus();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          color: const Color(0xFFFFFFFF),
          child: Column(
            children: [
              // 添加牧场选择器
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: weightInfoTree.when(
                  data: (options) => PickerPastureWidget(
                    options: options,
                    selectLast: SelectLast.pasture,
                    onChange: (values, isBld) {
                      selectedPasture = values;
                      // _fetchList(values); // 根据选择重新请求数据
                      print('选择的ID: $values, 是否为圈舍: $isBld');
                    },
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (err, _) => Text('加载牧场数据失败: $err'),
                ),
              ),

              // 显示数据列表
              Expanded(
                child: dataList.when(
                  data: (data) => data.isNotEmpty
                      ? _buildDataList(context, data)
                      : _buildNoDataWidget(),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('Error: $error')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


Widget _buildDataList(BuildContext context, List<dynamic> dataList) {
  return ListView.builder(
    itemCount: dataList.length,
    itemBuilder: (context, index) {
      final rowData = dataList[index];
      return Column(
        children: [
          ManualItem(
            rowData: rowData,
          ),
          const Divider(
            color: Color(0xFFE9E8E8),
            height: 0.5,
            indent: 12,
            endIndent: 12,
          ),
        ],
      );
    },
  );
}

class ManualItem extends StatelessWidget {
  final Map<String, dynamic> rowData;

  const ManualItem({
    super.key,
    required this.rowData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('序号', rowData["id"]),
        _buildInfoRow('圈舍名称', rowData["name"]),
        _buildInfoRow('可用状态', rowData["disabled"] ? '不可用' : '可用'),
      ],
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(
            '$label     ',
            style: const TextStyle(color: Color(0xFF666666)),
          ),
          Expanded(
            child: Text(
              value == null || value.isEmpty ? '未知' : value,
              style: const TextStyle(color: Color(0xFF666666)),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildNoDataWidget() {
  return Container(
    color: Colors.white,
    width: double.infinity,
    height: double.infinity,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty.png',
            fit: BoxFit.contain,
            width: double.infinity,
            height: 200,
          ),
          Transform.translate(
            offset: const Offset(0, -40),
            child: const Text(
              '没有查询到数据',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF666666),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}