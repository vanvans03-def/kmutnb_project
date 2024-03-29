import 'dart:convert';

import 'package:kmutnb_project/models/rating.dart';

class Product {
  final String productName;
  final String category;
  final String productShortDescription;
  final String productDescription;
  final double productPrice;
  final String productSalePrice;
  final List<String> productImage;
  final String productSKU;
  final String productType;
  final String stockStatus;
  final String relatedProduct;
  final String? id;
  final List<Rating>? rating;
  final String storeId;
  Product({
    required this.productName,
    required this.category,
    required this.productShortDescription,
    required this.productDescription,
    required this.productPrice,
    required this.productSalePrice,
    required this.productImage,
    required this.productSKU,
    required this.productType,
    required this.stockStatus,
    required this.relatedProduct,
    this.id,
    this.rating,
    required this.storeId,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'productName': productName,
      'category': category,
      'productShortDescription': productShortDescription,
      'productDescription': productDescription,
      'productPrice': productPrice,
      'productSalePrice': productSalePrice,
      'productImage': productImage,
      'productSKU': productSKU,
      'productType': productType,
      'stockStatus': stockStatus,
      'relatedProduct': relatedProduct,
      'rating': rating,
      'storeId': storeId,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      productName: map['productName'] ?? '',
      category: map['category'] ?? '',
      productShortDescription: map['productShortDescription'] ?? '',
      productDescription: map['productDescription'] ?? '',
      productPrice: map['productPrice']?.toDouble() ?? 0.0,
      productSalePrice: map['productSalePrice']?.toString() ?? '',
      productImage: List<String>.from(map['productImage']),
      productSKU: map['productSKU'] ?? '',
      productType: map['productType'] ?? '',
      stockStatus: map['stockStatus'] ?? '',
      relatedProduct: map['relatedProduct'] ?? '',
      id: map['_id'],
      rating: map['ratings'] != null
          ? List<Rating>.from(
              map['ratings']?.map(
                (x) => Rating.fromMap(x),
              ),
            )
          : null,
      storeId: map['storeId'],
    );
  }

  factory Product.fromJson(Map<String, dynamic> map) => Product.fromMap(map);

  String toJson() => json.encode(toMap());
}
