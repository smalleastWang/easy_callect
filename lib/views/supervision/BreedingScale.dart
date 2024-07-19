import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;
import 'package:easy_collect/api/mortgage.dart';
import 'package:easy_collect/enums/route.dart';
import 'package:easy_collect/models/mortgage/Mortgage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BreedingData {
  final String category;
  final int value;
  final Color color;

  BreedingData(this.category, this.value, this.color);
}

final mortgageInfoProvider = FutureProvider<Mortgage?>((ref) async {
  return await MyApi.getMortgageInfo({"id": null});
});

class BreedingScalePage extends ConsumerWidget {
  const BreedingScalePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Mortgage?> mortgageInfo = ref.watch(mortgageInfoProvider);

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
          final mortgage = mortgageInfo.mortgage ?? 0;
          final unMortgage = mortgageInfo.unMortgage ?? 0;

          String selectedCategory = '';
          int selectedValue = 0;

          List<charts.Series<BreedingData, String>> createDonutChartData() {
            final data = [
              BreedingData('抵押数量', mortgage, Colors.red),
              BreedingData('未抵押数量', unMortgage, Colors.orange),
            ];

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

          void onSelectionChanged(charts.SelectionModel model) {
            final selectedDatum = model.selectedDatum;
            if (selectedDatum.isNotEmpty) {
              final BreedingData selectedData = selectedDatum.first.datum;
              selectedCategory = selectedData.category;
              selectedValue = selectedData.value;
            }
          }

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
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const FaIcon(FontAwesomeIcons.lock, color: Colors.red),
                        const SizedBox(width: 16),
                        Text('抵押数量: $mortgage', style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const FaIcon(FontAwesomeIcons.unlock, color: Colors.blue),
                        const SizedBox(width: 16),
                        Text('未抵押数量: $unMortgage', style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Tooltip(
                  message: selectedCategory.isNotEmpty
                      ? '$selectedCategory: $selectedValue'
                      : '点击图表查看详情',
                  child: charts.PieChart<String>(
                    createDonutChartData(),
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
                    behaviors: [
                      charts.DatumLegend<String>(
                        outsideJustification: charts.OutsideJustification.endDrawArea,
                        horizontalFirst: false,
                        desiredMaxColumns: 1,
                        cellPadding: const EdgeInsets.only(right: 0, bottom: 0),
                        entryTextStyle: const charts.TextStyleSpec(
                          color: charts.MaterialPalette.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    selectionModels: [
                      charts.SelectionModelConfig(
                        type: charts.SelectionModelType.info,
                        changedListener: onSelectionChanged,
                      ),
                    ],
                  ),
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
