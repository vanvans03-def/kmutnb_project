import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kmutnb_project/constants/error_handling.dart';
import 'package:kmutnb_project/constants/global_variables.dart';
import 'package:kmutnb_project/constants/utills.dart';
import 'package:provider/provider.dart';
import '../../../models/store.dart';
import '../../../models/user.dart';
import '../../../providers/store_provider.dart';
import '../../../providers/user_provider.dart';

class ProfileService {
  void updateUser({
    required BuildContext context,
    required String fullName,
    required String phoneNumber,
    required String address,
    required File? productImage_,
    required bool select,
  }) async {
    try {
      String imageUrls = '';
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      if (select) {
        final cloudinary = CloudinaryPublic('dp6dsdn8y', 'x2sxr5vn');
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(productImage_!.path, folder: fullName),
        );
        imageUrls = (response.secureUrl);
      }

      http.Response res = await http.post(
        Uri.parse('$uri/api/updateUserData'),
        body: jsonEncode(
          {
            'id': userProvider.user.id,
            'image': imageUrls,
            'address': address,
            'fullName': fullName,
            'phoneNumber': phoneNumber
          },
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var responseJson = jsonDecode(res.body);
          var data = responseJson['data'];

          User user = userProvider.user.copyWith(
            image: data['image'],
            address: data['address'],
            fullName: data['fullName'],
            phoneNumber: data['phoneNumber'],
          );
          userProvider.setUserFromModel(user);
          showSnackBar(context, 'Updated Successfully!');
          Navigator.popUntil(context, (route) => route.isFirst);
        },
      );
    } catch (e) {
      //showSnackBar(context, e.toString());
    }
  }

  void updateStore(
      {required BuildContext context,
      required String storename,
      required String phone,
      required String storeDescription,
      required String province,
      required File? bannerImage_,
      required File? profiletImage_,
      required bool selectBanner,
      required bool selectProfile}) async {
    try {
      final storeProvider = Provider.of<StoreProvider>(context, listen: false);
      String profiletImageUrls = storeProvider.store.storeImage;
      String bannerImageUrls = storeProvider.store.banner;
      if (selectProfile) {
        final cloudinary = CloudinaryPublic('dp6dsdn8y', 'x2sxr5vn');
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(profiletImage_!.path, folder: storename),
        );
        profiletImageUrls = (response.secureUrl);
      }
      if (selectBanner) {
        final cloudinary = CloudinaryPublic('dp6dsdn8y', 'x2sxr5vn');
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(bannerImage_!.path, folder: storename),
        );
        bannerImageUrls = (response.secureUrl);
      }

      http.Response res = await http.put(
        Uri.parse('$uri/api/store'),
        body: jsonEncode(
          {
            'storeId': storeProvider.store.storeId,
            'storeName': storename,
            'storeImage': profiletImageUrls,
            'banner': bannerImageUrls,
            'storeDescription': storeDescription,
            'phone': phone,
            'province': province
          },
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var responseJson = jsonDecode(res.body);
          print(responseJson);
          var data = responseJson['data'];

          Store store = storeProvider.store.copyWith(
            storeName: data['storeName'],
            storeImage: data['storeImage'],
            banner: data['banner'],
            storeDescription: data['storeDescription'],
            phone: data['phone'],
            province: data['province'],
          );
          storeProvider.setStorerFromModel(store);
          showSnackBar(context, 'Updated Successfully!');
          Navigator.popUntil(context, (route) => route.isFirst);
        },
      );
    } catch (e) {
      //showSnackBar(context, e.toString());
    }
  }
}
