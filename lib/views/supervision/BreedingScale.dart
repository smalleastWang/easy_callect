import 'package:easy_collect/api/monitoring.dart';
import 'package:easy_collect/enums/route.dart';
import 'package:easy_collect/models/monitoring/Monitoring.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BreedingData {
  final String category;
  final int value;
  final Color color;

  BreedingData(this.category, this.value, this.color);
}

final mortgageInfoProvider = FutureProvider<Monitoring?>((ref) async {
  return await MonitoringApi.geScaleInfo({"id": null});
});

class BreedingScalePage extends ConsumerWidget {
  const BreedingScalePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Monitoring?> mortgageInfo = ref.watch(mortgageInfoProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(RouteEnum.breedingScale.title),
      ),
      body: mortgageInfo.when(
        data: (mortgageInfo) {
          if (mortgageInfo == null) {
            return const Center(child: Text('未获取到抵押信息'));
          }

          final cowNum = mortgageInfo.cowNum ?? 0;
          final pastureNum = mortgageInfo.pastureNum ?? 0;
          
          return Container(
            padding: const EdgeInsets.all(16.0),
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(
            //     colors: [Colors.blue[50]!, Colors.blue[100]!],
            //     begin: Alignment.topCenter,
            //     end: Alignment.bottomCenter,
            //   ),
            // ),
            child: Column(
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
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
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
