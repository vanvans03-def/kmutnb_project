import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductListProvider extends ChangeNotifier {
  List<Product> _productList = [];

  List<Product> get productList => _productList;

  void updateProductList(List<Product> productList) {
    _productList = productList;
    notifyListeners();
  }
}
