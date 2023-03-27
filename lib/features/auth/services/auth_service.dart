import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kmutnb_project/constants/error_handling.dart';
import 'package:kmutnb_project/constants/global_variables.dart';
import 'package:kmutnb_project/constants/utills.dart';
import 'package:kmutnb_project/features/admin/screens/admin_screen.dart';
import 'package:kmutnb_project/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:kmutnb_project/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/widgets/bottom_bar.dart';

class AuthService {
  // Sign up user
  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      User user = User(
        id: '',
        fullName: name,
        email: email,
        token: '',
        password: password,
        type: 'user',
        phoneNumber: '',
        address: '',
        cart: [],
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/register'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            'Account created! Login with the same credentials!',
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // Sign in user
  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/login'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var responseJson = jsonDecode(res.body);
          var data = responseJson['data'];
          var token = data['token'];
          print("login :");

          if (token == null) {
            // ignore: use_build_context_synchronously
            showSnackBar(context, 'Token is null');
            return;
          }

          // ignore: use_build_context_synchronously
          Provider.of<UserProvider>(context, listen: false)
              .setUser(responseJson);
          await prefs.setString('x-auth-token', token);

          if (data['type'] != 'admin' || data['type'] != 'merchant') {
            // ignore: use_build_context_synchronously
            /*   Navigator.pushNamedAndRemoveUntil(
              context,
              BottomBar.routeName,
              (route) => false,
            );*/
          } else if (data['type'] == 'admin') {
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminScreen(),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

//รอแก้
  // get data user
  void getUserData(
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
        return;
      }

      var tokenRes = await http.post(
        Uri.parse('$uri/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token
        },
      );

      var response = jsonDecode(tokenRes.body);

      if (response['success'] == true) {
        http.Response userRes = await http.get(
          Uri.parse('$uri/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );

        if (userRes.statusCode == 200) {
          var userProvider = Provider.of<UserProvider>(context, listen: false);
          // userProvider.setUser(userRes.body);
        }
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
