import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:kmutnb_project/constants/error_handling.dart';
import 'package:kmutnb_project/constants/global_variables.dart';
import 'package:kmutnb_project/constants/utills.dart';
import 'package:kmutnb_project/models/product.dart';
import 'package:http/http.dart' as http;

class AdminService {
  void sellProduct({
    required BuildContext context,
    required String productName,
    required String category,
    required String productShortDescription,
    required String productDescription,
    required double productPrice,
    required double productSalePrice,
    required List<File> productImage,
    required String productSKU,
    required String productType,
    required String stockStatus,
    required String relatedProduct,
    // required String id,
  }) async {
    try {
      final cloundinary = CloudinaryPublic('dp6dsdn8y', 'x2sxr5vn');
      List<String> imageUrls = [];

      for (int i = 0; i < productImage.length; i++) {
        CloudinaryResponse res = await cloundinary.uploadFile(
          CloudinaryFile.fromFile(productImage[i].path, folder: productName),
        );
        imageUrls.add(res.secureUrl);
      }
      Product product = Product(
        productName: productName,
        category: category,
        productShortDescription: productShortDescription,
        productDescription: productDescription,
        productPrice: productPrice,
        productSalePrice: productSalePrice,
        productImage: imageUrls,
        productSKU: productSKU,
        productType: productType,
        stockStatus: stockStatus,
        relatedProduct: relatedProduct,
        //  id: id,
      );

      http.Response res = await http.post(
        Uri.parse('$uri:4000/api/product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: product.toJson(),
      );
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Product Added Successfully!');
          Navigator.pop(context);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
