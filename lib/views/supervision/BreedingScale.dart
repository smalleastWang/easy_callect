import 'package:easy_collect/api/monitoring.dart';
import 'package:easy_collect/enums/route.dart';
import 'package:easy_collect/models/monitoring/Monitoring.dart';
import 'package:easy_collect/widgets/AreaSelector/AreaSelector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      final monitoringData = await MonitoringApi.geScaleInfo({
        "id": id,
      });
      state = AsyncValue.data(monitoringData);
    } catch (error) {
      print('error: $error');
    }
  }
}

class BreedingScalePage extends ConsumerStatefulWidget {
  const BreedingScalePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BreedingScalePageState createState() => _BreedingScalePageState();
}

class _BreedingScalePageState extends ConsumerState<BreedingScalePage> {
  String? selectedProvince;
  String? selectedCity;
  String? selectedDistrict;

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
        title: Text(RouteEnum.breedingScale.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            AreaSelector(
              enableCitySelection: true,
              // enableDistrictSelection: true,
              onAreaSelected: _onAreaSelected,
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: mortgageInfo.when(
                data: (data) {
                  if (data == null) {
                    return const Center(child: Text('未获取到抵押信息'));
                  }

                  final cowNum = data.cowNum ?? 0;
                  final pastureNum = data.pastureNum ?? 0;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildInfoCard(
                        "总牛只数量",
                        cowNum.toString(),
                        "assets/icon/svg/optimized/niu.svg",
                        bgColor: const Color(0xFFFC8731),
                        iconColor: Colors.white,
                      ),
                      const SizedBox(height: 16.0),
                      _buildInfoCard(
                        "牧场数量",
                        pastureNum.toString(),
                        "assets/icon/svg/optimized/muchang.svg",
                        bgColor: const Color(0xFF00BC7A),
                        iconColor: Colors.white,
                      )
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
