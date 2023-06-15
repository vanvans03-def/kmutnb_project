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
import 'package:kmutnb_project/models/productprice.dart';

import 'package:provider/provider.dart';

import '../../../models/category.dart';
import '../../../models/order.dart';
import '../../../models/orderStore.dart';
import '../../../providers/store_provider.dart';
import '../model/sales.dart';

class AdminService {
  void sellProduct({
    required BuildContext context,
    required String productName_,
    required String category_,
    required String productShortDescription_,
    required String productDescription_,
    required double productPrice_,
    required String productSalePrice_,
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

      final storeProvider = Provider.of<StoreProvider>(context, listen: false);

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
        storeId: storeProvider.store.storeId,
        //  id: id,
      );

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
          Navigator.popUntil(context, (route) => route.isFirst);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void updateProduct({
    required BuildContext context,
    required String productName_,
    required String category_,
    required String productShortDescription_,
    required String productDescription_,
    required double productPrice_,
    required String productSalePrice_,
    required List<File> productImage_,
    required String productSKU_,
    required String productType_,
    required String stockStatus_,
    required String relatedProduct_,
    required String productID,
    required List<String> imageWidget,

    // required String id,
  }) async {
    try {
      final cloudinary = CloudinaryPublic('dp6dsdn8y', 'x2sxr5vn');
      List<String> imageUrls = [];

      final storeProvider = Provider.of<StoreProvider>(context, listen: false);

      for (int i = 0; i < productImage_.length; i++) {
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(productImage_[i].path, folder: productName_),
        );
        imageUrls.add(res.secureUrl);
      }
      Product product;
      if (productImage_.isEmpty) {
        product = Product(
          productName: productName_,
          category: category_,
          productShortDescription: productShortDescription_,
          productDescription: productDescription_,
          productPrice: productPrice_,
          productSalePrice: productSalePrice_,
          productImage: imageWidget,
          productSKU: productSKU_,
          productType: productType_,
          stockStatus: stockStatus_,
          relatedProduct: relatedProduct_,
          storeId: storeProvider.store.storeId,
          //  id: id,
        );
      } else {
        product = Product(
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
          storeId: storeProvider.store.storeId,
          //  id: id,
        );
      }

      http.Response res = await http.put(
        Uri.parse('$uri/api/product/$productID'),
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
          showSnackBar(context, 'Product Added Successfully!');
          Navigator.popUntil(context, (route) => route.isFirst);
        },
      );
    } catch (e) {
      //showSnackBar(context, e.toString());
    }
  }

  void changStatusStockProduct({
    required BuildContext context,
    required Product productData,

    // required String id,
  }) async {
    try {
      //print(data);
      http.Response res = await http.put(
        Uri.parse('$uri/api/product/${productData.id}'),
        body: ({
          "productName": productData.productName,
          "category": productData.category,
          "productShortDescription": productData.productShortDescription,
          "productDescription": productData.productDescription,
          "productPrice": productData.productPrice,
          "productSalePrice": productData.productSalePrice,
          "productImage": productData.productImage,
          "productSKU": productData.productSKU,
          "productType": productData.productType,
          "stockStatus": 0,
          "storeId": productData.storeId,
          "ratings": productData.rating,
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
          showSnackBar(context, 'Product Added Successfully!');
          Navigator.popUntil(context, (route) => route.isFirst);
        },
      );
    } catch (e) {
      //showSnackBar(context, e.toString());
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

  Future<List<Product>> fetchAllProductUser({
    required BuildContext context,
    required String storeId,
  }) async {
    List<Product> productList = [];
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

      // ignore: use_build_context_synchronously
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

  Future<List<OrderStore>> fetchOrders(BuildContext context) async {
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    final storeId = storeProvider.store.storeId;
    List<OrderStore> orderList = [];
    try {
      http.Response res = await http
          .get(Uri.parse('$uri/api/order-merchant/$storeId'), headers: {
        'Content-Type': 'application/json; charset=UTF=8',
      });
      // ignore: use_build_context_synchronously
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              // print(jsonDecode(res.body)[i]);
              orderList.add(
                OrderStore.fromJson(
                  jsonEncode(jsonDecode(res.body)[i]),
                ),
              );
            }
          });
    } catch (e) {
      //showSnackBar(context, e.toString());
    }
    return orderList;
  }

  void changeOrderStatus({
    required BuildContext context,
    required int status,
    required String orderId,
    required String storeId,
    required String productId,
    required VoidCallback onSuccess,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/change-order-status'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8', // แก้ไขตรงนี้
        },
        body: jsonEncode(
          {
            'orderId': orderId,
            'storeId': storeId,
            'status': status,
            'productId': productId
          },
        ),
      );

      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          onSuccess();
        },
      );
    } catch (e) {
      //showSnackBar(context, e.toString());
    }
  }

  Future<Map<String, dynamic>> getEarnings(BuildContext context) async {
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    List<Sales> sales = [];
    final storeId = storeProvider.store.storeId;
    int totalEarning = 0;

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/analytics'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8', // แก้ไขตรงนี้
        },
        body: jsonEncode(
          {
            'storeId': storeId,
          },
        ),
      );
      // ignore: use_build_context_synchronously
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            var response = jsonDecode(res.body);

            totalEarning = response['totalEarnings'];
            sales = [
              Sales('Fruit', response['fruitEarnings']),
              Sales('Vegetable', response['vegetableEarnings']),
              Sales('Dry fruit', response['drtFruitEarnings']),
            ];
          });
    } catch (e) {
      //showSnackBar(context, e.toString());
    }
    return {
      'sales': sales,
      'totalEarnings': totalEarning,
    };
  }

  Future<Map<String, dynamic>> getEarningsByDate({
    required BuildContext context,
    required String startDate,
    required String endDate,
  }) async {
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    List<Sales> sales = [];
    final storeId = storeProvider.store.storeId;
    int totalEarning = 0;

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/analyticsByDate'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8', // แก้ไขตรงนี้
        },
        body: jsonEncode(
          {
            'storeId': storeId,
            'startDate': startDate,
            'endDate': endDate,
          },
        ),
      );
      // ignore: use_build_context_synchronously
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            var response = jsonDecode(res.body);
            print(response);
            totalEarning = response['totalEarnings'];
            sales = [
              Sales('Fruit', response['fruitEarnings']),
              Sales('Vegetable', response['vegetableEarnings']),
              Sales('Dry fruit', response['drtFruitEarnings']),
            ];
          });
    } catch (e) {
      //showSnackBar(context, e.toString());
    }
    return {
      'sales': sales,
      'totalEarnings': totalEarning,
    };
  }

  Future<List<ProductPrice>> fetchAllProductprice(BuildContext context) async {
    //final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<ProductPrice> productpricesList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/api/productprices'), headers: {
        'Content-Type': 'application/json; charset=UTF=8',
      });
      // ignore: use_build_context_synchronously
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            var responseJson = json.decode(res.body);
            var data = responseJson;

            for (int i = 0; i < data.length; i++) {
              productpricesList
                  .add(ProductPrice.fromJson(json.encode(data[i])));
            }
          });
    } catch (e) {
      //showSnackBar(context, e.toString());
    }
    return productpricesList;
  }

  Future<List<ProductPrice>> searchProductprice({
    required BuildContext context,
    required String productName,
  }) async {
    //final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<ProductPrice> productpricesList = [];
    try {
      http.Response res = await http.get(
          Uri.parse('$uri/api/productprices/search?productName=$productName'),
          headers: {
            'Content-Type': 'application/json; charset=UTF=8',
          });
      // ignore: use_build_context_synchronously
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            var responseJson = json.decode(res.body);
            var data = responseJson;

            for (int i = 0; i < data.length; i++) {
              productpricesList
                  .add(ProductPrice.fromJson(json.encode(data[i])));
            }
          });
    } catch (e) {
      // showSnackBar(context, e.toString());
    }
    return productpricesList;
  }

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
