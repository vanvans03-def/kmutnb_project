// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:kmutnb_project/features/admin/model/sales.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;

class CategoryProductsChart extends StatefulWidget {
  final List<Sales> sectors;
  int? totalsale;
  final List<charts.Series<Sales, String>> seriesList;
  final Function(DateTime, DateTime) onDateChanged;
  CategoryProductsChart({
    Key? key,
    required this.sectors,
    required this.seriesList,
    required this.totalsale,
    required this.onDateChanged,
  }) : super(key: key);

  @override
  _CategoryProductsChartState createState() => _CategoryProductsChartState();
}

class _CategoryProductsChartState extends State<CategoryProductsChart> {
  bool _isPieChart = true;
  String selectedCategory = '';
  double selectedValue = 0;
  final List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ToggleButtons(
          isSelected: [_isPieChart, !_isPieChart],
          onPressed: (index) {
            setState(() {
              _isPieChart = index == 0;
            });
          },
          children: const [
            Icon(Icons.bar_chart),
            Icon(Icons.pie_chart),
          ],
        ),
        AspectRatio(
          aspectRatio: 1.0,
          child: _isPieChart ? _buildBarChart(context) : _buildPieChart(),
        ),
        Text(
          'Total Sale : ${widget.totalsale} ฿ ',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 15),
        SingleChildScrollView(
          child: Column(
            children: [
              if (_isPieChart)
                Column(
                  children: [
                    Text('Selected Category: $selectedCategory'),
                    Text('Selected Value: $selectedValue'),
                  ],
                )
              else
                Column(
                  children: [
                    for (int i = 0; i < widget.sectors.length; i++)
                      InkWell(
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: colors[i % colors.length],
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                              height: 30,
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.sectors[i].label,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    // ignore: prefer_interpolation_to_compose_strings
                                    widget.sectors[i].earning.toString() + "฿",
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        sections: _chartSections(widget.sectors),
        centerSpaceRadius: 60.0,
        sectionsSpace: 5,
      ),
    );
  }

  Widget _buildBarChart(BuildContext context) {
    return charts.BarChart(
      widget.seriesList,
      animate: true,
      selectionModels: [
        charts.SelectionModelConfig(
          type: charts.SelectionModelType.info,
          changedListener: (charts.SelectionModel model) {
            if (model.hasDatumSelection) {
              final selectedDatum = model.selectedDatum.first;
              setState(() {
                selectedCategory = selectedDatum.datum.label;
                selectedValue = selectedDatum.datum.earning.toDouble();
              });

              // TODO: Handle the selected category and value
              // You can show a tooltip, navigate to a new screen, or perform any other action you need
            }
          },
        ),
      ],
    );
  }

  List<PieChartSectionData> _chartSections(List<Sales> sectors) {
    final List<PieChartSectionData> list = [];

    for (var i = 0; i < sectors.length; i++) {
      const double radius = 80.0;
      final data = PieChartSectionData(
        color: colors[i % colors.length],
        value: sectors[i].earning.toDouble(),
        radius: radius,
        title: sectors[i].label,
      );
      list.add(data);
    }

    return list;
  }
}
