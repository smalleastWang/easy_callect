import 'package:easy_collect/models/PageVo.dart';
import 'package:easy_collect/models/dropDownMenu/DropDownMenu.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/utils/tool/common.dart';
import 'package:easy_collect/widgets/Form/PickerFormField.dart';
import 'package:easy_collect/widgets/LoadingWidget.dart';
import 'package:easy_collect/widgets/Register/EnclosurePicker.dart';
import 'package:easy_collect/widgets/Search/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

enum Action { refresh, loading }

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


typedef Api<T> = Future<PageVoModel> Function(Map<String, dynamic> params);
typedef Builder = Widget Function(Map<String, dynamic> data);

class PastureModel {
  String field;
  List<EnclosureModel> options;
  PastureModel({required this.field, this.options = const []});
}

class ListWidget<T> extends ConsumerStatefulWidget {
  final List<DropDownMenuModel>? filterList;
  final Builder builder;
  // final Api<T>? api;
  final T provider;
  final PastureModel? pasture;
  final Map<String, dynamic>? params;
  const ListWidget({super.key, required this.builder, required this.provider, this.params, this.filterList, this.pasture});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ListWidgetState<T>();
}

class _ListWidgetState<T> extends ConsumerState<ListWidget> {
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

  // 获取table数据
  AsyncValue<PageVoModel>? _getList([int? current]) {
    // 数据加载完了
    if (params['current'] >= params['pages']) {
      _refreshController.loadNoData();
      return null;
    }
    // 加入筛选参数
    if (widget.pasture != null && _enclosureController.value != null) {
      final pastureVal = _enclosureController.value![_enclosureController.value!.length - 1];
      params.addAll({widget.pasture!.field: pastureVal});
    }
    // 加入分页参数
    params['current'] = current ?? params['current'] + 1;
    final AsyncValue<PageVoModel> res = ref.refresh(widget.provider(params));
    if (res.hasError) throw Exception(res.error);
    return res;
  }

  _handleFilter(String field, dynamic value) {
    params[field] = value;
    _getList(1);
  }
  void _onRefresh() async {
    action = Action.refresh;
    _getList(1);
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: EnclosurePickerWidget(
        scaffoldKey: _scaffoldKey,
        controller: _enclosureController,
        options: widget.pasture!.options, 
        decoration: getInputDecoration(
          // labelText: '牧场/圈舍',
          hintText: '请选择牧场/圈舍',
        ),
        onChange: (value) {
          action = Action.refresh;
          _refreshController.requestRefresh();
          _getList(1);
        },
      )
    );
  }

  Widget get _searchWidget {
    if (widget.filterList == null) return const SizedBox.shrink();
    return SearchWidget(filterList: widget.filterList!, onChange: _handleFilter);
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
      key: _scaffoldKey,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _pastureWidget,
          _searchWidget,
          widget.filterList != null ? SearchWidget(filterList: widget.filterList!, onChange: _handleFilter) : const SizedBox.shrink(),
          LoadingWidget(
            data: data,
            builder: (BuildContext context, PageVoModel value) {
              if (value.records.isEmpty) {
                return _buildNoDataWidget();
              }
              // 更新分页信息
              params['current'] = value.current;
              params['pages'] = value.pages;
              params['size'] = value.size;
              params['total'] = value.total;
              return Expanded(
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
                    noDataText: "没有更多数据了", //没有内容的文字
                    // noMoreIcon: ,
                  ),
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
                )
                
                
              );
            }
          )
        ],
      ),
    );
  }
}