import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kmutnb_project/models/product.dart';

import '../../product_details/services/product_details_service.dart';

class ProductListProvider with ChangeNotifier {
  final ProductDetailsServices _productDetailsService =
      ProductDetailsServices();
  Map<String, Product> _productList = {};

  Map<String, Product> get productList => _productList;

  get context => null;

  Future<void> findProductListById(List<String> productIds) async {
    for (String productId in productIds) {
      if (_productList[productId] == null) {
        Product product = await _productDetailsService.findProductId(
          id: productId,
          context: context,
        );
        _productList[productId] = product;
      }
    }
    notifyListeners();
  }

  Product findProductById(String productId) {
    return _productList[productId]!;
  }
}
