import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kmutnb_project/providers/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utills.dart';
import '../../../models/order.dart';
import '../../auth/screens/auth_screen.dart';

class AccountServices {
  Future<List<Order>> fetchMyOrder(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final uId = userProvider.user.id;
    List<Order> orderList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/api/order-me/$uId'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      });

      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          List<dynamic> decodedData = jsonDecode(res.body);
          orderList =
              decodedData.map<Order>((item) => Order.fromMap(item)).toList();
        },
      );
    } catch (e) {
      //showSnackBar(context, e.toString());
    }
    return orderList;
  }

  void logOut(BuildContext context) async {
    try {
      Provider.of<UserProvider>(context, listen: false).clearUserData();

      Navigator.pushNamedAndRemoveUntil(
        context,
        AuthScreen.routeName,
        (route) => false,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
