import 'dart:convert';

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
import 'package:shared_preferences/shared_preferences.dart';

enum Action { refresh, loading }

typedef Api<T> = Future<PageVoModel> Function(Map<String, dynamic> params);
typedef Builder = Widget Function(Map<String, dynamic> data);

class PastureModel {
  SelectLast? selectLast;
  // 查询的字段名 
  // 如果 selectLast是 SelectLast.both 用,隔开 如：'orgId,bldId' 前面是牧场字段名 后面是圈舍字段名
  String field;
  List<EnclosureModel> options;
  PastureModel({required this.field, this.options = const [], this.selectLast});
}

///
/// 列表组件
/// 参数 {pasture} 牧场筛选
/// 参数 {searchForm} 自定义删选
/// 参数 {filterList} 下拉筛选
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
  final bool isCustomCard;
  const ListWidget({super.key, required this.builder, required this.provider, this.params, this.filterList, this.pasture, this.searchForm, this.isCustomCard = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ListWidgetState<T>();
}

class ListWidgetState<T> extends ConsumerState<ListWidget> {
  Action? action;
  bool loading = false;
  Map<String, dynamic> params = {
    'current': 0,
    'pages': 1,
    'size': 15,
    'total': 0,
  };

  // 定义刷新控制器
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  final PickerEditingController _enclosureController = PickerEditingController();

  bool _pastureLastIsBld = false;

  @override
  void initState() {
    if (widget.params != null) {
      params.addAll(widget.params!);
    }
    _getList();
    Future.delayed(const Duration(seconds: 10),(){

      
    });
    super.initState();
  }

  Future<void> _saveCurrentParams() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('queryParams', json.encode(params));
  }

  getList(Map<String, dynamic> query) {
    params.addAll(query);
    return _getList(1);
  }

  refreshWithPreviousParams() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? savedParams = prefs.getString('queryParams');
    if (savedParams != null) {
      // params = Map<String, dynamic>.from(json.decode(savedParams));
      params.removeWhere((key, value) => true);
      params.addAll(json.decode(savedParams));
      _fetchData();
    }
  }

  // 获取table数据
  AsyncValue<PageVoModel>? _getList([int? current, bool? isRefresh]) {
    if (current == 1) {
      setState(() {
        loading = true;
      });
    }
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

    return _fetchData(isRefresh);
  }

  // 调用接口
  AsyncValue<PageVoModel>? _fetchData([bool? isRefresh]) {
    // 加入筛选参数
    if (widget.pasture != null && _enclosureController.value != null) {
      if (widget.pasture!.selectLast == SelectLast.both && _pastureLastIsBld && _enclosureController.value!.length >= 2) {
        List fields = widget.pasture!.field.split(',');
        String pastureField = fields[0];
        String shedField = fields[1];
        String shedVal = _enclosureController.value![_enclosureController.value!.length - 2];
        params.addAll({pastureField: _enclosureController.value!.last, shedField: shedVal});
      } else {
        final pastureVal = _enclosureController.value!.last;
        params.addAll({widget.pasture!.field: pastureVal});
      }
    }

    // 保存当前的查询参数
    _saveCurrentParams();
    // 去除空的map项
    params.removeWhere((key, value) => value == null || value == 'null');
    // 请求数据
    final AsyncValue<PageVoModel> res = ref.refresh(widget.provider(params));
    ref.listenManual(widget.provider(params), (previous, next) {
      if (params['current'] != 1 || isRefresh == true) {
        setState(() {
          loading = false;
        });
        return;
      } 
      if (previous != null && params['current'] == 1) {
        setState(() {
          loading = !(previous as dynamic).isLoading;
        });
      }
    });
    
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
        selectLast: widget.pasture!.selectLast ?? SelectLast.pasture,
        options: widget.pasture!.options,
        onChange: (values, lastIsBld) {
          setState(() {
            _pastureLastIsBld = lastIsBld;
          });
          _enclosureController.value = values;
          _getList(1);
        }
      ),
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

  @override
  Widget build(BuildContext context) {
    final AsyncValue<PageVoModel> data = ref.watch(widget.provider(params));

    _handleAction(data);
    return Scaffold(
      body: Column(
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
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: RefreshConfiguration(
                headerBuilder: () => const ClassicHeader(
                  idleText: "下拉刷新",
                  refreshingText: "数据加载中...",
                  completeText: "加载成功",
                  releaseText: "松开立即刷新",
                  failedText: '刷新失败',
                ),
                footerBuilder: () => const ClassicFooter(
                  idleText: "上拉加载",
                  loadingText: "加载中…",
                  canLoadingText: "松手开始加载数据",
                  failedText: "加载失败",
                  noDataText: "没有更多数据了",
                ),
                child: SmartRefresher(
                  enablePullUp: true,
                  controller: _refreshController,
                  onLoading: _onLoading,
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
                      if (loading) return const Center(child: CircularProgressIndicator());
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: value.records.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (widget.isCustomCard) return widget.builder(value.records[index]);
                          return Container(
                            margin: const EdgeInsets.only(top: 6),
                            padding: const EdgeInsets.only(top: 14, left: 12, right: 12, bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6)
                            ),
                            child: widget.builder(value.records[index]),
                          );
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