import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;
import 'package:easy_collect/api/monitoring.dart';
import 'package:easy_collect/enums/route.dart';
import 'package:easy_collect/models/monitoring/Monitoring.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:easy_collect/widgets/AreaSelector/AreaSelector.dart';

class BreedingData {
  final String category;
  final int value;
  final Color color;

  BreedingData(this.category, this.value, this.color);
}

class HealthInfoPage extends ConsumerStatefulWidget {
  const HealthInfoPage({super.key});

  @override
  _HealthInfoPageState createState() => _HealthInfoPageState();
}

class _HealthInfoPageState extends ConsumerState<HealthInfoPage> {
  String? selectedProvince;
  String? selectedCity;
  AsyncValue<Monitoring> mortgageInfo = const AsyncValue.loading();

  @override
  void initState() {
    super.initState();
    _fetchMortgageInfo();
  }

  void _fetchMortgageInfo() {
    final id = selectedCity ?? selectedProvince;
    final provider = getHealthInfoProvider({
      'id': id,
    });
    ref.read(provider.future).then((data) {
      setState(() {
        mortgageInfo = AsyncValue.data(data);
      });
    }).catchError((error) {
      print('error: $error');
    });
  }

  void _onAreaSelected(String? province, String? city) {
    setState(() {
      selectedProvince = province;
      selectedCity = city;
      _fetchMortgageInfo(); // Fetch data when area selection changes
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(RouteEnum.healthInfo.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              AreaSelector(
                enableCitySelection: true,
                onAreaSelected: _onAreaSelected,
              ),
              const SizedBox(height: 16.0),
              mortgageInfo.when(
                data: (data) => _buildContent(context, data),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Monitoring data) {
    if (data == null) {
      return _buildNoDataWidget();
    }

    final breedingData = _getBreedingData(data);
    String selectedCategory = '';
    int selectedValue = 0;
    return Column(
      children: [
        _buildInfoGrid(data),
        if (data.cowNum != null && data.cowNum! > 0) ...[
          _buildPieChart(context, breedingData,(selectedDatum) {
              setState(() {
                selectedCategory = selectedDatum.category;
                selectedValue = selectedDatum.value;
                EasyLoading.showToast(
                  '$selectedCategory: $selectedValue',
                  duration: const Duration(seconds: 2),
                  toastPosition: EasyLoadingToastPosition.bottom,
                );
              });
            },
          ),
          _buildLegend(breedingData),
        ],
      ],
    );
  }

  Widget _buildNoDataWidget() {
    return const Center(child: Text('未获取到投保信息'));
  }

  List<BreedingData> _getBreedingData(Monitoring data) {
    final health = data.health ?? 0;
    final unHealth = data.unHealth ?? 0;

    return [
      BreedingData('健康数量', health, const Color(0xFFFA3D01)),
      BreedingData('不健康数量', unHealth, const Color(0xFFFFC960)),
    ];
  }

  Widget _buildInfoGrid(Monitoring data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          return _buildInfoCard(
            _getInfoCardTitle(index),
            _getInfoCardValue(index, data),
            _getInfoCardIcon(index),
            bgColor: _getInfoCardBgColor(index),
            iconColor: Colors.white,
          );
        },
      ),
    );
  }

  String _getInfoCardTitle(int index) {
    switch (index) {
      case 0: return '总牛只数';
      case 1: return '牧场数量';
      case 2: return '健康数量';
      case 3: return '不健康数量';
      default: return '';
    }
  }

  String _getInfoCardValue(int index, Monitoring data) {
    switch (index) {
      case 0: return data.cowNum?.toString() ?? '0';
      case 1: return data.pastureNum?.toString() ?? '0';
      case 2: return data.health?.toString() ?? '0';
      case 3: return data.unHealth?.toString() ?? '0';
      default: return '0';
    }
  }

  String _getInfoCardIcon(int index) {
    switch (index) {
      case 0: return 'assets/icon/svg/optimized/niu.svg';
      case 1: return 'assets/icon/svg/optimized/muchang.svg';
      case 2:
      case 3: return 'assets/icon/svg/optimized/love.svg';
      default: return '';
    }
  }

  Color _getInfoCardBgColor(int index) {
    switch (index) {
      case 0: return const Color(0xFFFC8731);
      case 1: return const Color(0xFF00BC7A);
      case 2: return const Color(0xFFFA3D01);
      case 3: return const Color(0xFFFFC960);
      default: return Colors.green;
    }
  }

  Widget _buildPieChart(BuildContext context, List<BreedingData> breedingData, Function(BreedingData) onSelect,) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Tooltip(
        message: '点击图表查看详情',
        child: Transform.translate(
          offset: const Offset(0, -5),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: charts.PieChart<String>(
              _createDonutChartData(breedingData),
              animate: true,
              defaultRenderer: charts.ArcRendererConfig<String>(
                arcWidth: 60,
                startAngle: 1 / 5 * 3.14,
                strokeWidthPx: 0.0,
                arcRendererDecorators: [
                  charts.ArcLabelDecorator<String>(
                    labelPosition: charts.ArcLabelPosition.inside,
                  ),
                ],
              ),
              behaviors: [
                charts.SelectNearest(), // 添加此行为以确保用户可以选择最近的数据点
                charts.DomainHighlighter(), // 高亮选中的区域
              ],
              selectionModels: [
                charts.SelectionModelConfig(
                  type: charts.SelectionModelType.info,
                  changedListener: (model) {
                    final selectedDatum = model.selectedDatum;
                    if (selectedDatum.isNotEmpty) {
                      final BreedingData selectedData = selectedDatum.first.datum;
                      onSelect(selectedData);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<charts.Series<BreedingData, String>> _createDonutChartData(List<BreedingData> data) {
    final total = data.fold(0, (sum, item) => sum + item.value);

    return [
      charts.Series<BreedingData, String>(
        id: 'Breeding Data',
        colorFn: (BreedingData data, _) => charts.ColorUtil.fromDartColor(data.color),
        domainFn: (BreedingData data, _) => data.category,
        measureFn: (BreedingData data, _) => data.value,
        data: data,
        labelAccessorFn: (BreedingData row, _) {
          final percentage = (row.value / total * 100).toStringAsFixed(1);
          return '$percentage%';
        },
      )
    ];
  }

  Widget _buildLegend(List<BreedingData> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: data.map((item) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: item.color,
                  shape: BoxShape.rectangle,
                ),
              ),
              const SizedBox(width: 4),
              Text(item.category),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInfoCard(
    String title,
    String count,
    String iconPath, {
    Color bgColor = Colors.blue,
    Color iconColor = Colors.white,
  }) {
    return Card(
      color: const Color(0xFFF6F7FD),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.all(8.0),
              child: iconPath.endsWith('.svg')
                  ? SvgPicture.asset(iconPath, fit: BoxFit.fill)
                  : Image.asset(iconPath, fit: BoxFit.fill),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    count,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF000000),
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}