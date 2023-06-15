// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../../../models/province.dart';
import '../services/home_service.dart';

class MapScreen extends StatefulWidget {
  static const routeName = '/map';
  double currentLat;
  double currentLng;
  MapScreen({
    Key? key,
    required this.currentLat,
    required this.currentLng,
  }) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapController mapController = MapController();
  var marker = <Marker>[];
  bool isTapped = false;
  String address = '';
  List<Province> provinceList = [];

  @override
  void initState() {
    super.initState();
    updateMarker(widget.currentLat, widget.currentLng);
    updateMarkerInfo(widget.currentLat, widget.currentLng);
  }

  void updateMarker(double lat, double long) {
    setState(() {
      marker = [
        Marker(
          width: 30.0,
          height: 30.0,
          point: LatLng(lat, long),
          builder: (ctx) => const Icon(
            Icons.location_pin,
            color: Colors.red,
          ),
        ),
      ];
    });
  }

  void updateMarkerInfo(double lat, double lng) async {
    String address = await reverseGeocoding(lat, lng);
    setState(() {
      this.address = address;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Screen'),
      ),
      body: Center(
        child: Column(
          children: [
            if (isTapped)
              Container(
                margin:
                    const EdgeInsets.only(left: 0, top: 1, right: 0, bottom: 0),
                padding: const EdgeInsets.all(8.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200], // กำหนดสีพื้นหลังเป็นเทา
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: Colors.grey), // กำหนดสีเส้นรอบวงเป็นเทา
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        address,
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 12.0),
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                margin:
                    const EdgeInsets.only(left: 0, top: 1, right: 0, bottom: 0),
                padding: const EdgeInsets.all(8.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200], // กำหนดสีพื้นหลังเป็นเทา
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: Colors.grey), // กำหนดสีเส้นรอบวงเป็นเทา
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.location_pin,
                      color: Colors.red,
                    ),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        'กรุณาเลือกตำแหน่งที่ตั้งเพื่อค้นหาร้านค้าใกล้คุณ',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ),
                  ],
                ),
              ),
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  onTap: (tapPosition, point) {
                    setState(() {
                      isTapped = true;
                      String pointString = point.toString();
                      String latString = pointString.substring(
                          pointString.indexOf('latitude:') + 9,
                          pointString.indexOf(','));
                      String longString = pointString.substring(
                          pointString.indexOf('longitude:') + 10,
                          pointString.indexOf(')'));

                      double latitude = double.parse(latString);
                      double longitude = double.parse(longString);

                      updateMarker(latitude, longitude);
                      updateMarkerInfo(latitude, longitude);
                    });
                  },
                  center: LatLng(widget.currentLat, widget.currentLng),
                  zoom: 12.0,
                  maxZoom: 18,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                  ),
                  // เพิ่ม MarkerLayerOptions หากต้องการใส่ตัวชี้แผนที่บนแผนที่

                  MarkerLayer(
                    markers: marker,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () async {
          HomeService homeService = HomeService();
          String province = address.split(',')[4].trim();
          province = province.replaceAll('จังหวัด', '');
          provinceList = await homeService.fetchAllProvinceByOption(
            context: context,
            provinceName: province,
            type: 'nearMe',
          );

          Navigator.pop(context, provinceList);
        },
      ),
    );
  }
}

Future<String> reverseGeocoding(double latitude, double longitude) async {
  String url =
      'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude&zoom=18&addressdetails=1';

  var response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    var jsonData = jsonDecode(response.body);
    String road = jsonData['address']['road'] ?? '-';
    String village = jsonData['address']['village'] ?? '-';
    String town = jsonData['address']['town'] ?? '-';
    String city = jsonData['address']['city'] ?? '-';
    String state = jsonData['address']['state'] ?? '-';

    // ignore: unused_local_variable
    String address = '$road, $village, $town, $city, $state';

    return address;
  } else {
    return '';
  }
}
