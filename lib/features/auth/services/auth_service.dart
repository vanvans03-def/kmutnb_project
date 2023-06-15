import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kmutnb_project/constants/error_handling.dart';
import 'package:kmutnb_project/constants/global_variables.dart';
import 'package:kmutnb_project/constants/utills.dart';
import 'package:kmutnb_project/features/admin/screens/admin_screen.dart';

import 'package:kmutnb_project/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:kmutnb_project/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../providers/store_provider.dart';

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
        type: 'merchant',
        phoneNumber: '',
        address: '',
        cart: [],
        image: '',
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

  void registerUserOauth({
    required BuildContext context,
    required String id,
    required String email,
    required String password,
    required String name,
    required String token,
    required String image,
  }) async {
    try {
      User user = User(
        id: id,
        fullName: name,
        email: email,
        token: token,
        password: id,
        type: 'user',
        phoneNumber: '',
        address: '',
        cart: [],
        image: image,
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/register'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          showSnackBar(
            context,
            'Register success pleas Login',
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
          // ignore: use_build_context_synchronously

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
          } else if (data['type'] == 'merchant') {
            // ignore: use_build_context_synchronously, await_only_futures

            // ignore: use_build_context_synchronously
            Navigator.pushNamedAndRemoveUntil(
              context,
              AdminScreen.routeName,
              (route) => false, // ลบทุกหน้าออกจาก Stack
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> getStoreData({
    required BuildContext context,
  }) async {
    try {
      // ignore: use_build_context_synchronously
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final uid = userProvider.user.id;

      http.Response res = await http.get(
        Uri.parse('$uri/api/my-store/$uid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var data;
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var responseJson = json.decode(res.body);
          data = responseJson['data'];
          if (data == null) {
            Navigator.pushReplacementNamed(
              context,
              '/add-store',
            );
          } else {
            Provider.of<StoreProvider>(context, listen: false).setStore(data);
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
      rethrow;
    }
  }
}

class GoogleSignInApi {
  static final _googleSignIn = GoogleSignIn();
  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();

  static Future logout() => _googleSignIn.disconnect();
}
