import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_collect/api/monitoring.dart';
import 'package:easy_collect/enums/route.dart';
import 'package:easy_collect/models/monitoring/Monitoring.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart'; // 导入 EasyLoading
import 'package:easy_collect/widgets/AreaSelector/AreaSelector.dart'; // 导入 AreaSelector

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
      final monitoringData = await MonitoringApi.getHealthInfo({
        "id": id,
      });
      state = AsyncValue.data(monitoringData);
    } catch (error) {
      print('error: $error');
    }
  }
}

class HealthInfoPage extends ConsumerStatefulWidget {
  const HealthInfoPage({super.key});

  @override
  _HealthInfoPageState createState() => _HealthInfoPageState();
}

class _HealthInfoPageState extends ConsumerState<HealthInfoPage> {
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
        title: Text(RouteEnum.healthInfo.title),
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
    return const Center(child: Text('未获取到健康信息'));
  }

  Widget _buildDataWidget(BuildContext context, Monitoring data) {
    final breedingData = _getBreedingData(data);

    return StatefulBuilder(
      builder: (context, setState) {
        int touchedIndex = -1;
        int lastTouchedIndex = -1; // 用于存储上一次触摸的索引

        return Column(
          children: [
            _buildInfoGrid(data),
             if (data.cowNum != null && data.cowNum! > 0) ...[
              _buildPieChart(context, breedingData, setState, (index) {
                if (lastTouchedIndex != index) {
                  lastTouchedIndex = index;
                  final item = breedingData[index];
                  EasyLoading.showToast(
                    '${item.category} ${item.value}',
                    duration: const Duration(seconds: 2),
                    toastPosition: EasyLoadingToastPosition.bottom,
                  );
                }
                touchedIndex = index;
              }),
              _buildLegend(breedingData),
            ]
          ],
        );
      },
    );
  }

  List<BreedingData> _getBreedingData(Monitoring data) {
    final health = data.health ?? 0;
    final unHealth = data.unHealth ?? 0;

    return [
      BreedingData('健康数量', health, const Color(0xFF00BC7A)),
      BreedingData('不健康数量', unHealth, const Color(0xFFFFC960)),
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
      case 2: return const Color(0xFF00BC7A);
      case 3: return const Color(0xFFFFC960);
      default: return Colors.green;
    }
  }

  Widget _buildPieChart(
    BuildContext context,
    List<BreedingData> breedingData,
    StateSetter setState,
    Function(int) onTouch
  ) {
    final pieChartData = _createPieChartData(breedingData);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Tooltip(
        message: '点击图表查看详情',
        child: Transform.translate(
          offset: const Offset(0, -30),
          child: SizedBox(
            height: 400,
            child: PieChart(
              PieChartData(
                sections: pieChartData,
                centerSpaceRadius: 100,
                sectionsSpace: 0,
                borderData: FlBorderData(show: false),
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      return;
                    }
                    final index = pieTouchResponse.touchedSection!.touchedSectionIndex;
                    setState(() => onTouch(index));
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _createPieChartData(List<BreedingData> data) {
    final total = data.fold(0, (sum, item) => sum + item.value);

    return data.map((item) {
      final percentage = (item.value / total * 100).toStringAsFixed(1);

      return PieChartSectionData(
        color: item.color,
        value: item.value.toDouble(),
        title: '$percentage%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
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
              const SizedBox(width: 8),
              Text(item.category),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInfoCard(
    String title,
    String value,
    String icon, {
    Color bgColor = Colors.green,
    Color iconColor = Colors.white,
  }) {
    return Card(
      color: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              width: 24,
              height: 24,
              color: iconColor,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}