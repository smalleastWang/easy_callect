import 'package:easy_collect/api/monitoring.dart';
import 'package:easy_collect/enums/route.dart';
import 'package:easy_collect/models/monitoring/Monitoring.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const FaIcon(FontAwesomeIcons.cow, color: Colors.brown),
                        const SizedBox(width: 8),
                        Text('总牛只数: $cowNum', style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const FaIcon(FontAwesomeIcons.seedling, color: Colors.green),
                        const SizedBox(width: 16),
                        Text('牧场数量: $pastureNum', style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
