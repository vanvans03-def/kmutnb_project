import 'dart:convert';
import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:kmutnb_project/constants/error_handling.dart';
import 'package:kmutnb_project/constants/global_variables.dart';
import 'package:kmutnb_project/constants/utills.dart';
import 'package:kmutnb_project/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:kmutnb_project/providers/user_provider.dart';

import 'package:provider/provider.dart';

import '../../../models/category.dart';
import '../../../models/order.dart';

class AdminService {
  void sellProduct({
    required BuildContext context,
    required String productName_,
    required String category_,
    required String productShortDescription_,
    required String productDescription_,
    required double productPrice_,
    required double productSalePrice_,
    required List<File> productImage_,
    required String productSKU_,
    required String productType_,
    required String stockStatus_,
    required String relatedProduct_,
    // required String id,
  }) async {
    try {
      final cloudinary = CloudinaryPublic('dp6dsdn8y', 'x2sxr5vn');
      List<String> imageUrls = [];

      for (int i = 0; i < productImage_.length; i++) {
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(productImage_[i].path, folder: productName_),
        );
        imageUrls.add(res.secureUrl);
      }

      Product product = Product(
        productName: productName_,
        category: category_,
        productShortDescription: productShortDescription_,
        productDescription: productDescription_,
        productPrice: productPrice_,
        productSalePrice: productSalePrice_,
        productImage: imageUrls,
        productSKU: productSKU_,
        productType: productType_,
        stockStatus: stockStatus_,
        relatedProduct: relatedProduct_,
        //  id: id,
      );
      //print("this is product object");
      //print(product.productName);

      final data = jsonEncode(product);
      //print(data);
      http.Response res = await http.post(
        Uri.parse('$uri/api/product'),
        body: product.toJson(),
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
          Navigator.pop(context);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //get all
  Future<List<Product>> fetchAllProduct(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
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
    final userProvider = Provider.of<UserProvider>(context, listen: false);
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
