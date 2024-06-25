import 'package:collection/collection.dart';
import 'package:easy_collect/models/PageVo.dart';
import 'package:easy_collect/models/dropDownMenu/DropDownMenu.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/widgets/Form/PickerFormField.dart';
import 'package:easy_collect/widgets/List/PickerPastureWidget.dart';
import 'package:easy_collect/widgets/Search/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

enum Action { refresh, loading }

typedef Api<T> = Future<PageVoModel> Function(Map<String, dynamic> params);
typedef Builder = Widget Function(Map<String, dynamic> data);

class PastureModel {
  String field;
  List<EnclosureModel> options;
  PastureModel({required this.field, this.options = const []});
}

///
/// 列表组件
/// 参数 {pasture} 牧场筛选
/// 参数 {searchForm} 自定义删选
/// 参数 {filterList} 下拉塞选
/// 
/// builder 可以用  ListItemWidget 组件 也可以传入自定义组件
///
class ListWidget<T> extends ConsumerStatefulWidget {
  final List<DropDownMenuModel>? filterList;
  final Builder builder;
  final T provider;
  final PastureModel? pasture;
  final Map<String, dynamic>? params;
  final Widget? searchForm;
  const ListWidget({super.key, required this.builder, required this.provider, this.params, this.filterList, this.pasture, this.searchForm});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ListWidgetState<T>();
}

class ListWidgetState<T> extends ConsumerState<ListWidget> {
  Action? action;
  Map<String, dynamic> params = {
    'current': 0,
    'pages': 1,
    'size': 15,
    'total': 0,
  };

  // 定义刷新控制器
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  final PickerEditingController _enclosureController = PickerEditingController();

  @override
  void initState() {
    if (widget.params != null) {
      params.addAll(widget.params!);
    }
    _getList();
    // ref.listenManual(widget.provider(filterData), (previous, next) {

    // });
    super.initState();
  }

  getList(Map<String, dynamic> query) {
    params.addAll(query);
    return _getList(1);
  }

  // 获取table数据
  AsyncValue<PageVoModel>? _getList([int? current, bool? isRefresh]) {
    // 判断是否需要刷新
    if (isRefresh == true || current == 1) {
      params['current'] = 1; // 重置为第一页
    } else {
      // 数据加载完了
      if (params['current'] >= params['pages']) {
        _refreshController.loadNoData();
        return null;
      }
      // 加入分页参数
      params['current'] = current ?? params['current'] + 1;
    }

    // 加入筛选参数
    if (widget.pasture != null && _enclosureController.value != null) {
      final pastureVal = _enclosureController.value![_enclosureController.value!.length - 1];
      params.addAll({widget.pasture!.field: pastureVal});
    }

    // 请求数据
    final AsyncValue<PageVoModel> res = ref.refresh(widget.provider(params));
    if (res.hasError) {
      print('Error: ${res.error}');
      throw Exception(res.error);
    }

    return res;
  }

  _handleFilter(String field, dynamic value) {
    if (field.contains(',')) {
      List<String> fields = field.split(',');
      List<String> values = value.split(',');
      fields.forEachIndexed((index, e) {
        params[fields[index]] = values[index];
      });
    } else {
      params[field] = value;
    }
    _getList(1);
  }
  void _onRefresh() async {
    action = Action.refresh;
    _getList(1, true);
  }
  void _onLoading() async {
    action = Action.loading;
    _getList();
  }
  _handleAction (AsyncValue<PageVoModel> asyncValue) {
    if (asyncValue.hasError) {
      if (action == Action.refresh) {
        _refreshController.refreshFailed();
      } else if (action == Action.loading) {
        _refreshController.loadFailed();
      }
    } else {
      if (action == Action.refresh) {
        _refreshController.refreshCompleted(resetFooterState: true);
      } else if (action == Action.loading) {
        _refreshController.loadComplete();
        
      }
    }
    action == null;
  }

  Widget get _pastureWidget {
    if (widget.pasture == null) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: PickerPastureWidget(
        options: widget.pasture!.options,
      ),
      // child: EnclosurePickerWidget(
      //   // scaffoldKey: _scaffoldKey,
      //   controller: _enclosureController,
      //   options: widget.pasture!.options, 
      //   decoration: getInputDecoration(
      //     // labelText: '牧场/圈舍',
      //     hintText: '请选择牧场/圈舍',
      //   ),
      //   onChange: (value) {
      //     action = Action.refresh;
      //     _refreshController.requestRefresh();
      //     _getList(1);
      //   },
      // )
    );
  }

  Widget get _dropDownSearchWidget {
    if (widget.filterList == null) return const SizedBox.shrink();
    return SearchWidget(filterList: widget.filterList!, onChange: _handleFilter);
  }
  Widget get _getSearchForm {
    if (widget.searchForm == null) return const SizedBox.shrink();
    return widget.searchForm!;
  }

  Widget _buildNoDataWidget() {
    return const Center(
      child: Text(
        '没有查询到数据',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<PageVoModel> data = ref.watch(widget.provider(params));

    _handleAction(data);
    return  Scaffold(
      body:Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _pastureWidget,
          _getSearchForm,
          _dropDownSearchWidget,
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9)
              ),
              child: RefreshConfiguration(
                headerBuilder: () => const ClassicHeader(
                  idleText: "下拉刷新",
                  refreshingText: "数据加载中...",
                  completeText: "加载成功",
                  releaseText: "松开立即刷新",
                  failedText: '刷新失败',
                ),
                footerBuilder:  () => const ClassicFooter(
                  idleText: "上拉加载",
                  loadingText: "加载中…",
                  canLoadingText: "松手开始加载数据",
                  failedText: "加载失败",
                  noDataText: "没有更多数据了",
                ),
                child: SmartRefresher(
                  enablePullUp: true,
                  controller: _refreshController,
                  onLoading:_onLoading,
                  onRefresh: _onRefresh,
                  child: data.when(
                    data: (PageVoModel value) {
                      if (value.total <= 0) {
                        return _buildNoDataWidget();
                      }
                      // 更新分页信息
                      params['current'] = value.current;
                      params['pages'] = value.pages;
                      params['size'] = value.size;
                      params['total'] = value.total;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: value.records.length,
                        itemBuilder: (BuildContext context, int index) {
                          return widget.builder(value.records[index]);
                        }
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Center(child: Text('加载数据时出错: $err')),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}