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

class BreedingScalePage extends ConsumerStatefulWidget {
  const BreedingScalePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BreedingScalePageState();
}

class _BreedingScalePageState extends ConsumerState<BreedingScalePage> {
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
    final provider = getScaleInfoProvider({
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
                data: (Monitoring? data) {
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
