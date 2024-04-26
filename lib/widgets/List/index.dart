import 'package:easy_collect/models/PageVo.dart';
import 'package:easy_collect/models/dropDownMenu/DropDownMenu.dart';
import 'package:easy_collect/widgets/LoadingWidget.dart';
import 'package:easy_collect/widgets/Search/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


typedef Api<T> = Future<PageVoModel> Function(Map<String, dynamic> params);
typedef Builder = Widget Function(Map<String, dynamic> data);

class ListWidget<T> extends ConsumerStatefulWidget {
  final List<DropDownMenuModel>? filterList;
  final Builder builder;
  // final Api<T>? api;
  final T provider;
  final Map<String, dynamic>? params;
  const ListWidget({super.key, required this.builder, required this.provider, this.params, this.filterList});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ListWidgetState<T>();
}

class _ListWidgetState<T> extends ConsumerState<ListWidget> {
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
    // _getList();
    // ref.listenManual(widget.provider(filterData), (previous, next) {

    // });
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
    // 加入筛选参数
    params.addAll(filterData);

    // 加入分页参数
    params.addAll({
      'current': current ?? pageData.current + 1,
      'size': pageData.size
    });
    // PageVoModel res = await widget.api!(params);
    final AsyncValue<PageVoModel> res =  ref.refresh(widget.provider(filterData));
    if (res.hasError) throw Exception(res.error);

    pageData.current = res.value!.current;
    pageData.pages = res.value!.pages;
    pageData.size = res.value!.size;
    pageData.total = res.value!.total;
    
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
    final AsyncValue<PageVoModel> data = ref.watch(widget.provider(filterData));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        widget.filterList != null ? SearchWidget(filterList: widget.filterList!, onChange: _handleFilter) : const SizedBox.shrink(),
        LoadingWidget(
          data: data,
          builder: (BuildContext context, PageVoModel value) {
            return Expanded(
              child: SmartRefresher(
                enablePullUp: true,
                controller: _refreshController,
                onLoading:_onLoading,
                onRefresh: _onRefresh,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: value.records.length,
                  itemBuilder: (BuildContext context, int index) {
                    return widget.builder(value.records[index]);
                  }
                ),
              )
            );
          }
        )
      ],
    );
  }
}