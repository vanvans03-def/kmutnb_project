import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kmutnb_project/features/auth/widgets/constants.dart';
import 'package:kmutnb_project/features/home/screens/filter_product.dart';
import 'package:kmutnb_project/features/home/services/home_service.dart';
import 'package:kmutnb_project/features/home/widgets/dropdown_widget.dart';
import 'package:kmutnb_project/features/home/widgets/map_screen.dart';
import 'package:kmutnb_project/features/store/services/add_store_service.dart';

import '../../../models/product.dart';
import '../../../models/province.dart';

class FilterWidget extends StatefulWidget {
  final String? provinceByGPS;
  const FilterWidget({Key? key, this.provinceByGPS});
  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  double minPrice = 0.0;
  double maxPrice = 0.0;
  bool sortByPriceLow = false;
  bool sortByPriceHigh = false;
  bool isTaps = false;
  String label = '';
  final ProvinceService provinceService = ProvinceService();
  List<Province> provinces = [];
  String selectedProvinceId = '';
  Key dropdownKey = UniqueKey();
  String keyword = '';

  @override
  void initState() {
    super.initState();

    minPrice = 0.0; // เพิ่มค่า default
    maxPrice = 0.0; // เพิ่มค่า default
  }

  HomeService homeService = HomeService();
  void _openMapScreen(double lat, double lng) async {
    final value = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(
          currentLat: lat,
          currentLng: lng,
        ),
      ),
    );

    if (value != null) {
      provinces = value;
      setState(() {
        selectedProvinceId = provinces[0].id.toString();
        label = '${provinces[0].officialRegion} รอบๆตัวฉัน';
        isTaps = true;
      });
    }
  }

  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    // อย่าลืม dispose controller เมื่อสิ้นสุดการใช้งาน
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Keyword',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Material(
                  borderRadius: BorderRadius.circular(7),
                  elevation: 1,
                  child: TextFormField(
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {
                        keyword = value;
                      });
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(
                          left: 6,
                        ),
                        child: Icon(
                          Icons.search,
                          color: Colors.black,
                          size: 23,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.only(top: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(7),
                        ),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(7),
                        ),
                        borderSide: BorderSide(
                          color: Colors.black38,
                          width: 1,
                        ),
                      ),
                      hintText: 'Search ',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
                if (isTaps) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        'Location Store',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownWidget(
                        provinces: provinces,
                        selectedProvinceId: selectedProvinceId,
                        onChanged: (String? newVal) async {
                          setState(() {
                            selectedProvinceId = newVal!.toString();
                          });
                        },
                        label: label,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.location_pin),
                              label: const Text(
                                'แสดงร้านค้ารอบๆตัวฉัน',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                              onPressed: () async {
                                Position data = await _determinePosition();

                                String latString = data.toString().substring(
                                    data.toString().indexOf('Latitude:') + 9,
                                    data.toString().indexOf(','));
                                String longString = data.toString().substring(
                                    data.toString().indexOf('Longitude:') + 10);

                                double latitude = double.parse(latString);
                                double longitude = double.parse(longString);

                                _openMapScreen(latitude, longitude);
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.map),
                              label: const Text(
                                'เฉพาะร้านค้าในกรุงเทพ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                              onPressed: () async {
                                provinces =
                                    await homeService.fetchAllProvinceByOption(
                                  context: context,
                                  provinceName: 'กรุงเทพมหานคร',
                                  type: 'OnlyBKK',
                                );
                                setState(() {
                                  selectedProvinceId = provinces.first.id;
                                  label = "กรุงเทพมหานคร";
                                  isTaps = true;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.near_me),
                              label: const Text(
                                'กรุงเทพมหานครและปริมณฑล',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                              onPressed: () async {
                                provinces =
                                    await homeService.fetchAllProvinceByOption(
                                  context: context,
                                  provinceName: 'กรุงเทพมหานคร',
                                  type: 'perimeter',
                                );
                                setState(() {
                                  selectedProvinceId =
                                      provinces[0].id.toString();
                                  label = "กรุงเทพมาหนครและปริมณฑล";
                                  isTaps = true;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.near_me_disabled),
                              label: const Text(
                                'ทุกร้านค้าในประเทศไทย',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                              onPressed: () async {
                                provinces =
                                    await homeService.fetchAllProvinceByOption(
                                  context: context,
                                  provinceName: 'กรุงเทพมหานคร',
                                  type: 'All',
                                );
                                setState(() {
                                  provinces.insert(
                                    0,
                                    Province(
                                      id: "",
                                      provinceThai:
                                          "เลือกจากทุกจังหวัดในประเทศไทย",
                                      area: '',
                                      bangkokMetropolitan: '',
                                      femalePopulation62: '',
                                      fourRegion: '',
                                      malePopulation62: '',
                                      officialRegion: '',
                                      population62: '',
                                      provinceEng:
                                          '-Select from all provinces in Thailand-',
                                      provinceID: '',
                                      tourismRegion: '',
                                    ),
                                  );
                                  selectedProvinceId =
                                      provinces[0].id.toString();
                                  label = "77 จังหวัด";
                                  isTaps = true;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Price Range',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Min Price',
                        ),
                        onChanged: (value) {
                          setState(() {
                            minPrice = double.tryParse(value) ?? 0;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Max Price',
                        ),
                        onChanged: (value) {
                          setState(() {
                            maxPrice = double.tryParse(value) ?? 0;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Sort By',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: sortByPriceLow,
                      onChanged: (value) {
                        setState(() {
                          sortByPriceLow = value ?? false;
                        });
                      },
                    ),
                    const Text('Sort by Price (Low to High)'),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: sortByPriceHigh,
                      onChanged: (value) {
                        setState(() {
                          sortByPriceHigh = value ?? false;
                        });
                      },
                    ),
                    const Text('Sort by Price (High to Low)'),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _applyFilters();
                    Navigator.pop(context);
                  },
                  child: const Text('Apply Filters'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Product> productList = [];
  Future<void> _applyFilters() async {
    productList = await homeService.fetchFilterProduct(
      context: context,
      minPrice: minPrice,
      maxPrice: maxPrice,
      sortByPriceLow: sortByPriceLow,
      sortByPriceHigh: sortByPriceHigh,
      province: selectedProvinceId,
      productName: keyword,
    );

    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilterProduct(products: productList),
      ),
    );
  }
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    await Geolocator.openLocationSettings();
    return Future.error('Location services are disabled.');
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }
  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permission are permanently denide,');
  }
  return await Geolocator.getCurrentPosition();
}
