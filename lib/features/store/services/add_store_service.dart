import 'dart:convert';
import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:kmutnb_project/constants/error_handling.dart';
import 'package:kmutnb_project/constants/global_variables.dart';
import 'package:kmutnb_project/constants/utills.dart';
import 'package:kmutnb_project/features/auth/services/auth_service.dart';
import 'package:kmutnb_project/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:kmutnb_project/models/store.dart';
import 'package:kmutnb_project/providers/user_provider.dart';

import 'package:provider/provider.dart';

import '../../../models/order.dart';
import '../../../models/province.dart';
import '../../../providers/store_provider.dart';

class AddStoreService {
  void createStore({
    required BuildContext context,
    required String storetName_,
    required File storeImage_,
    required File banner_,
    required String phone_,
    required String storeShortDescription_,
    required String storetDescription_,
    required String storeStatus_,
    required String user_,
    required String province_,
    required String idcardNo_,

    // required String id,
  }) async {
    try {
      String profileImageUrls = '';
      String bannerImageUrls = '';
      final storeProvider = Provider.of<StoreProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      Store store = Store(
        storeId: storeProvider.store.storeId,
        storeName: storetName_,
        banner: bannerImageUrls,
        phone: phone_,
        storeDescription: storetDescription_,
        storeImage: profileImageUrls,
        storeShortDescription: '',
        storeStatus: '0',
        user: userProvider.user.id,
        province: province_,
        idcardImage: profileImageUrls,
        idcardNo: idcardNo_,
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/store'),
        body: store.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          //showSnackBar(context, 'Product Added Successfully!');
          Navigator.popAndPushNamed(context, '/admin-screen');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //get all
  Future<List<Product>> fetchAllProduct(BuildContext context) async {
    List<Product> productList = [];
    final AuthService authService = AuthService();
    await authService.getStoreData(context: context);
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    final storeId = storeProvider.store.storeId;
    try {
      http.Response res = await http
          .get(Uri.parse('$uri/api/product/store/$storeId'), headers: {
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

  void deleteProduct({
    required BuildContext context,
    required Product product,
    required VoidCallback onSuccess,
  }) async {
    try {
      http.Response res = await http
          .delete(Uri.parse('$uri/api/product/${product.id}'), headers: {
        'Content-Type': 'application/json; charset=UTF=8',
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          onSuccess();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<List<Order>> fetchAllOrders(BuildContext context) async {
    List<Order> orderList = [];
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
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              orderList.add(
                Order.fromJson(
                  jsonEncode(jsonDecode(res.body)[i]),
                ),
              );
            }
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return orderList;
  }
}

class ProvinceService {
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

            //data น่าจะมาไม่ครบ
          }
          print(data.length);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return provinceList;
  }
}
