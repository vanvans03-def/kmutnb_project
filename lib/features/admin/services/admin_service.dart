import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:kmutnb_project/constants/utills.dart';
import 'package:kmutnb_project/models/product.dart';

class AdminService {
  void sellProduct({
    required BuildContext context,
    required String productName,
    required String category,
    required String productShortDescription,
    required double productPrice,
    required double productSalePrice,
    required List<File> productImage,
    required String productSKU,
    required String productType,
    required String stockStatus,
    required String relatedProduct,
    required String id,
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
        productPrice: productPrice,
        productSalePrice: productSalePrice, //5.28
        productImage: imageUrls,
        productSKU: productSKU,
        productType: productType,
        stockStatus: stockStatus,
        relatedProduct: relatedProduct,
        id: id,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
