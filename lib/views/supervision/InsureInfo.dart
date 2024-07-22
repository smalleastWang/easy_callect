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

final mortgageInfoProvider = StateNotifierProvider<MonitoringNotifier, AsyncValue<Monitoring?>>((ref) {
  return MonitoringNotifier();
});

class MonitoringNotifier extends StateNotifier<AsyncValue<Monitoring?>> {
  MonitoringNotifier() : super(const AsyncValue.loading());

  Future<void> fetchMonitoringData({String? provinceId, String? cityId}) async {
    try {
      final id = cityId ?? provinceId;
      final monitoringData = await MonitoringApi.getInsureInfo({
        "id": id,
      });
      state = AsyncValue.data(monitoringData);
    } catch (error) {
      print('error: $error');
    }
  }
}

class InsureInfoPage extends ConsumerStatefulWidget {
  const InsureInfoPage({super.key});

  @override
  _InsureInfoPageState createState() => _InsureInfoPageState();
}

class _InsureInfoPageState extends ConsumerState<InsureInfoPage> {
  String? selectedProvince;
  String? selectedCity;

  @override
  void initState() {
    super.initState();
    ref.read(mortgageInfoProvider.notifier).fetchMonitoringData();
  }

  void _onAreaSelected(String? province, String? city) {
    setState(() {
      selectedProvince = province;
      selectedCity = city;
    });

    ref.read(mortgageInfoProvider.notifier).fetchMonitoringData(
      provinceId: province,
      cityId: city,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<Monitoring?> mortgageInfo = ref.watch(mortgageInfoProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(RouteEnum.insureInfo.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            AreaSelector(
              enableCitySelection: true,
              onAreaSelected: _onAreaSelected,
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: mortgageInfo.when(
                data: (data) => data == null
                    ? _buildNoDataWidget()
                    : _buildDataWidget(context, data),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoDataWidget() {
    return const Center(child: Text('未获取到投保信息'));
  }

  Widget _buildDataWidget(BuildContext context, Monitoring data) {
    final breedingData = _getBreedingData(data);

    return StatefulBuilder(
      builder: (context, setState) {
        String selectedCategory = '';
        int selectedValue = 0;

        return Column(
          children: [
            _buildInfoGrid(data),
            if (data.cowNum != null && data.cowNum! > 0) ...[
              _buildPieChart(
                context,
                breedingData,
                (selectedDatum) {
                  setState(() {
                    selectedCategory = selectedDatum.category;
                    selectedValue = selectedDatum.value;
                    EasyLoading.showToast(
                      '$selectedCategory: $selectedValue',
                      duration: const Duration(seconds: 2),
                      toastPosition: EasyLoadingToastPosition.bottom,
                    );
                  });
                }
              ),
              _buildLegend(breedingData),
            ],
          ],
        );
      },
    );
  }

  List<BreedingData> _getBreedingData(Monitoring data) {
    final policy = data.policy ?? 0;
    final unPolicy = data.unPolicy ?? 0;

    return [
      BreedingData('投保数量', policy, const Color(0xFF3B81F2)),
      BreedingData('未投保数量', unPolicy, const Color(0xFF82A2D5)),
    ];
  }

  Widget _buildInfoGrid(Monitoring data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
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
      case 2: return '投保数量';
      case 3: return '未投保数量';
      default: return '';
    }
  }

  String _getInfoCardValue(int index, Monitoring data) {
    switch (index) {
      case 0: return data.cowNum?.toString() ?? '0';
      case 1: return data.pastureNum?.toString() ?? '0';
      case 2: return data.policy?.toString() ?? '0';
      case 3: return data.unPolicy?.toString() ?? '0';
      default: return '0';
    }
  }

  String _getInfoCardIcon(int index) {
    switch (index) {
      case 0: return 'assets/icon/svg/optimized/niu.svg';
      case 1: return 'assets/icon/svg/optimized/muchang.svg';
      case 2: return 'assets/icon/svg/optimized/toubao.svg';
      case 3: return 'assets/icon/svg/optimized/toubao.svg';
      default: return '';
    }
  }

  Color _getInfoCardBgColor(int index) {
    switch (index) {
      case 0: return const Color(0xFFFC8731);
      case 1: return const Color(0xFF00BC7A);
      case 2: return const Color(0xFF3B81F2);
      case 3: return const Color(0xFF82A2D5);
      default: return Colors.green;
    }
  }

  Widget _buildPieChart(
    BuildContext context,
    List<BreedingData> breedingData,
    Function(BreedingData) onSelect
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Tooltip(
        message: '点击图表查看详情',
        child: Transform.translate(
          offset: const Offset(0, -30),
          child: SizedBox(
            height: 400,
            child: charts.PieChart<String>(
              _createDonutChartData(breedingData),
              animate: true,
              defaultRenderer: charts.ArcRendererConfig<String>(
                arcWidth: 60,
                startAngle: 4 / 5 * 3.14,
                strokeWidthPx: 0.0,
                arcRendererDecorators: [
                  charts.ArcLabelDecorator<String>(
                    labelPosition: charts.ArcLabelPosition.inside,
                  ),
                ],
              ),
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
    Color bgColor = Colors.green,
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