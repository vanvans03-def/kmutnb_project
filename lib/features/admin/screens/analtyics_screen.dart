import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:kmutnb_project/features/admin/services/admin_service.dart';
import 'package:kmutnb_project/features/admin/widgets/category_product_chart.dart';

import '../../../common/widgets/loader.dart';
import '../model/sales.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AdminService adminService = AdminService();
  int? totalSales;
  List<Sales>? earnings;
  late DateTime startDate;
  late DateTime endDate;
  String start = "";
  String end = "";

  @override
  void initState() {
    super.initState();
    getEarnings();
    startDate = DateTime.now();
    endDate = DateTime.now();
  }

  Future<void> getEarnings() async {
    var earningsData = await adminService.getEarningsByDate(
      context: context,
      endDate: end,
      startDate: start,
    );
    totalSales = earningsData['totalEarnings'];
    earnings = earningsData['sales'];
    setState(() {});
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
      initialDateRange: DateTimeRange(start: startDate, end: endDate),
    );
    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
        start = startDate.toString().substring(0, 10);
        end = endDate.toString().substring(0, 10);
      });
      start = startDate.toString().substring(0, 10);
      end = endDate.toString().substring(0, 10);
      await getEarnings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return earnings == null || totalSales == null
        ? const Loader()
        : Scaffold(
            body: Container(
              margin: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () => _selectDateRange(context),
                                icon: const Icon(
                                  Icons.calendar_today,
                                  color: Colors.orange,
                                  size: 40.0, // ปรับขนาด icon เป็น 80.0
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'From Date: ${startDate.toString().substring(0, 10)}',
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                    ), // ขนาดตัวอักษร 18.0, ตัวหนา
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    ' To Date: ${endDate.toString().substring(0, 10)}',
                                    style: const TextStyle(
                                        fontSize:
                                            12.0), // ขนาดตัวอักษร 18.0, ตัวหนา
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    CategoryProductsChart(
                      key: UniqueKey(),
                      sectors: earnings!,
                      seriesList: [
                        charts.Series(
                          id: 'Sales',
                          data: earnings!,
                          domainFn: (Sales sales, _) => sales.label,
                          measureFn: (Sales sales, _) => sales.earning,
                        )
                      ],
                      totalsale: totalSales,
                      onDateChanged:
                          (DateTime newStartDate, DateTime newEndDate) {
                        setState(() {
                          startDate = newStartDate;
                          endDate = newEndDate;
                          start = startDate.toString().substring(0, 10);
                          end = endDate.toString().substring(0, 10);
                        });
                        getEarnings();
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              start = "";
                              end = "";
                            });
                            getEarnings();
                          },
                          child: const Text(
                            'แสดงทั้งหมด',
                            style: TextStyle(
                                fontSize: 12.0), // ปรับขนาดตัวอักษรเป็น 12.0
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
