import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utills.dart';
import '../../../models/product.dart';

class SearchServices {
  Future<List<Product>> fetchAllProduct({
    required BuildContext context,
    required String searchQuery,
  }) async {
    List<Product> productList = [];
    try {
      http.Response res = await http.get(
          Uri.parse('$uri/api/product/search?keyword=$searchQuery'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          });
      // ignore: use_build_context_synchronously
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            var responseJson = json.decode(res.body);

            var data = responseJson['data'];

            for (int i = 0; i < data.length; i++) {
              productList.add(
                Product.fromJson(data[i] as Map<String, dynamic>),
              );
            }
          });
      print(
          productList); // ตรวจสอบค่า productList หลังจากที่สินค้าถูกเพิ่มในลูป for
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return productList;
  }
}
