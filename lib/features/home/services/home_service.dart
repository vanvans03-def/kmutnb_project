import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kmutnb_project/constants/utills.dart';
import 'package:provider/provider.dart';
import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';
import '../../../models/category.dart';
import '../../../models/product.dart';
import '../../../providers/user_provider.dart';

class HomeService {
  Future<List<Product>> fetchAllProduct(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/api/product'), headers: {
        'Content-Type': 'application/json; charset=UTF=8',
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
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return productList;
  }

  Future<List<Category>> fetchAllCategory(BuildContext context) async {
    List<Category> categoriesList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/category'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var responseJson = json.decode(res.body);
          var data = responseJson['data'];

          for (int i = 0; i < data.length; i++) {
            categoriesList.add(Category.fromJson(json.encode(data[i])));
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return categoriesList;
  }
}
