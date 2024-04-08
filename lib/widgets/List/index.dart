import 'package:easy_collect/models/PageVo.dart';
import 'package:easy_collect/models/dropDownMenu/DropDownMenu.dart';
import 'package:easy_collect/widgets/List/ListItem.dart';
import 'package:easy_collect/widgets/Search/index.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


typedef Api<T> = Future<PageVoModel> Function(Map<String, dynamic> params);

class ListWidget<T> extends StatefulWidget {
  final List<DropDownMenuModel>? filterList;
  final List<ListColumnModal> columns;
  final List<Map<String, dynamic>>? data;
  final Api<T>? api;
  final Map<String, dynamic>? params;
  const ListWidget({super.key, required this.columns, this.data, required this.api, this.params, this.filterList});

  @override
  State<ListWidget> createState() => _ListWidgetState<T>();
}

class _ListWidgetState<T> extends State<ListWidget> {
  Map<String, dynamic> filterData = {};

  // 定义刷新控制器
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  
  PageVoModel pageData = PageVoModel(
    current: 0,
    pages: 1,
    size: 10,
    total: 0,
    records: []
  );

  @override
  void initState() {
    if (widget.data == null) {
      if (widget.api == null) {
        throw Exception('List组件data和api参数必传一个');
      }
      Future.delayed(const Duration(milliseconds: 100)).then((value) {
        _getList();
      });
    } else {
      setState(() {
        pageData = PageVoModel(current: 1, pages: 1, size: widget.data?.length ?? 1, total: widget.data?.length ?? 1, records: widget.data!);
      });
    }
    super.initState();
  }

  // 获取table数据
  _getList([int? current]) async {
    Map<String, dynamic> params = widget.params ?? {};
    // 数据加载完了
    if (pageData.current >= pageData.pages) {
      _refreshController.loadNoData();
      return;
    }
    // TODO: 加入筛选参数
    params.addAll(filterData);

    // 加入分页参数
    params.addAll({
      'current': current ?? pageData.current + 1,
      'size': pageData.size
    });
    PageVoModel res = await widget.api!(params);
    // 不是第一页在前面插入原数据
    if (current != 1) {
      res.records.insertAll(0, pageData.records);
    }
    setState(() {
      pageData = res;
    });
  }

  _handleFilter(String field, dynamic value) {
    filterData[field] = value;
    _getList(1);
  }
  void _onRefresh() async {
    try {
      await _getList(1);
      _refreshController.refreshCompleted(resetFooterState: true);
    } catch(e) {
      _refreshController.refreshFailed();
    }
    // 重置获取数据LoadStatus
    
  }
  void _onLoading() async {
    try {
      await _getList();
      _refreshController.loadComplete();
    } catch(e) {
      _refreshController.loadFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        widget.filterList != null ? SearchWidget(filterList: widget.filterList!, onChange: _handleFilter) : const SizedBox.shrink(),
        Expanded(
          child: SmartRefresher(
            enablePullUp: true,
            controller: _refreshController,
            onLoading:_onLoading,
            onRefresh: _onRefresh,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: pageData.records.length,
              itemBuilder: (BuildContext context, int index) {
                return ListItemWidget(rowData: pageData.records[index], columns: widget.columns,);
              }
            ),
          )
        )
      ],
    );
  }
}