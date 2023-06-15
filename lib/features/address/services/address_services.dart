import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kmutnb_project/constants/error_handling.dart';
import 'package:kmutnb_project/constants/global_variables.dart';
import 'package:kmutnb_project/constants/utills.dart';
import 'package:http/http.dart' as http;
import 'package:kmutnb_project/providers/user_provider.dart';

import 'package:provider/provider.dart';

import '../../../models/category.dart';
import '../../../models/user.dart';

class AddressService {
  void saveUser({
    required BuildContext context,
    required String address,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/save-user-address'),
        body: jsonEncode({
          'UserEmail': userProvider.user.email,
          'Address': address,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          User user = userProvider.user.copyWith(
            address: jsonDecode(res.body)['address'],
          );
          userProvider.setUserFromModel(user);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void placeOrder({
    required BuildContext context,
    required String address,
    required double totalSum,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.post(Uri.parse('$uri/api/order'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'cart': userProvider.user.cart,
            'address': address,
            'totalPrice': totalSum,
            'userId': userProvider.user.id
          }));

      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          print(res.body);
          showSnackBar(context, "You order is saved");

          User user = userProvider.user.copyWith(
            cart: [],
          );
          userProvider.setUserFromModel(user);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<String?> getQrCode({
    required BuildContext context,
    required double totalSum,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$uri/api/generateQR'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'totalAmount': totalSum,
          'storeTel': '0989503183',
        }),
      );

      if (res.statusCode == 200) {
        final responseJson = json.decode(res.body);
        final data = responseJson['Result'];
        return data;
      } else {
        showSnackBar(context, 'Error: ${res.statusCode}');
        return null;
      }
    } catch (e) {
      showSnackBar(context, e.toString());
      return null;
    }
  }

  Future<Category> getCategory({
    required BuildContext context,
    required String categoryId,
  }) async {
    final completer = Completer<Category>();

    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/category/$categoryId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var responseJson = json.decode(res.body);
          var data = responseJson["data"];
          completer.complete(Category.fromJson(data));
        },
      );
    } catch (e) {
      //showSnackBar(context, e.toString());
      //completer.completeError(e);
    }

    return completer.future;
  }
}

class CategoryService {
  Future<List<Category>> fetchAllCategory(BuildContext context) async {
    //final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Category> categoriesList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/api/category'), headers: {
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
              categoriesList.add(Category.fromJson(json.encode(data[i])));
            }
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return categoriesList;
  }
}
