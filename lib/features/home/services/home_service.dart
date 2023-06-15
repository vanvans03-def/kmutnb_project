import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kmutnb_project/constants/utills.dart';
import 'package:kmutnb_project/models/productprice.dart';

import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';
import '../../../models/category.dart';
import '../../../models/product.dart';
import '../../../models/province.dart';
import '../../../models/store.dart';

class HomeService {
  Future<List<Product>> fetchAllProduct(BuildContext context) async {
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

  Future<List<Product>> fetchFilterProduct({
    required BuildContext context,
    required double minPrice,
    required double maxPrice,
    required bool sortByPriceLow,
    required bool sortByPriceHigh,
    required String province,
    required String productName,
  }) async {
    List<Product> productList = [];
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/filter-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "minPrice": minPrice,
          "maxPrice": maxPrice,
          "sortByPriceLow": sortByPriceLow,
          "sortByPriceHigh": sortByPriceHigh,
          "province": province,
          "productName": productName
        }),
      );

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
      //showSnackBar(context, e.toString());
    }
    return productList;
  }

  Future<List<Product>> fetchProductDeal(BuildContext context) async {
    List<Product> productList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/api/deal-of-day'), headers: {
        'Content-Type': 'application/json; charset=UTF=8',
      });
      // ignore: use_build_context_synchronously
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            var responseJson = json.decode(res.body);

            for (int i = 0; i < responseJson.length; i++) {
              productList.add(
                Product.fromJson(responseJson[i] as Map<String, dynamic>),
              );
            }
          });
    } catch (e) {
      //showSnackBar(context, e.toString());
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

  Future<List<Store>> fetchAllStore(BuildContext context) async {
    List<Store> storeList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/store'),
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
            storeList.add(Store.fromJson(json.encode(data[i])));
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return storeList;
  }

  Future<ProductPrice> findProductPriceById({
    required BuildContext context,
    required String id,
  }) async {
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/api/productprices/$id'), headers: {
        'Content-Type': 'application/json; charset=UTF=8',
      });

      // ignore: use_build_context_synchronously
      var data;
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var responseJson = json.decode(res.body);
          data = responseJson;
          //print(data);
        },
      );
      return ProductPrice.fromJson(data);
    } catch (e) {
      showSnackBar(context, e.toString());
      rethrow;
    }
  }

  Future<List<Province>> fetchAllProvinceByOption({
    required BuildContext context,
    required String provinceName,
    required String type,
  }) async {
    List<Province> provinceList = [];
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/provinceNearMe'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "provinceThai": provinceName,
          "type": type,
        }),
      );

      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var responseJson = json.decode(res.body);

          for (int i = 0; i < responseJson.length; i++) {
            Province province = Province.fromMap(responseJson[i]);
            provinceList.add(province);
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return provinceList;
  }

  Future<List<Province>> fetchAllProvince(BuildContext context) async {
    List<Province> provinceList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/api/province'), headers: {
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
            Province province = Province.fromMap(data[i]);
            provinceList.add(province);
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return provinceList;
  }
}
