import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utills.dart';
import '../../../models/product.dart';
import '../../../models/user.dart';
import '../../../providers/user_provider.dart';

class ProductDetailsServices {
  void addToCart({
    required BuildContext context,
    required Product product,

    // required String id,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final data = jsonEncode(product);
      //print(data);
      http.Response res = await http.post(
        Uri.parse('$uri/api/rate-product'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization': userProvider.user.token,
        },
        body: jsonEncode({
          'id': product.id!,
        }),
      );
      //print(userProvider.user.token);
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var responseJson = jsonDecode(res.body);
          var data = responseJson['data'];
          //showSnackBar(context, 'Product Added Successfully!');
          User user = userProvider.user.copyWith(cart: data['cart']);
          userProvider.setUserFromModel(user);

          User.fromMap(data.body);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void rateProduct({
    required BuildContext context,
    required Product product,
    required double rating,
    // required String id,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final data = jsonEncode(product);
      //print(data);
      http.Response res = await http.post(
        Uri.parse('$uri/api/rate-product'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization': userProvider.user.token,
        },
        body: jsonEncode({
          'id': product.id!,
          'rating': rating,
        }),
      );
      //print(userProvider.user.token);
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          //showSnackBar(context, 'Product Added Successfully!');
          Navigator.pop(context);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
