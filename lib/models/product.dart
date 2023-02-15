// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  Product({
    this.message,
    this.data,
    required String productName,
    required String category,
    required String productShortDescription,
    required double productPrice,
    required double productSalePrice,
    required List<String> productImage,
    required String productSKU,
    required String productType,
    required String stockStatus,
    required String relatedProduct,
    required String id,
  });

  String? message;
  Data? data;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        productName: '',
        category: '',
        id: '',
        productImage: [],
        productPrice: 0,
        productSKU: '',
        productSalePrice: 0,
        productShortDescription: '',
        productType: '',
        relatedProduct: '',
        stockStatus: '',
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  Data({
    this.productName,
    this.category,
    this.productShortDescription,
    this.productDescription,
    this.productPrice,
    this.productSalePrice,
    this.productImage,
    this.productSku,
    this.productType,
    this.stockStatus,
    this.relatedProduct,
    this.id,
    this.v,
  });

  String? productName;
  String? category;
  String? productShortDescription;
  String? productDescription;
  double? productPrice;
  double? productSalePrice;
  String? productImage;
  String? productSku;
  String? productType;
  String? stockStatus;
  List<dynamic>? relatedProduct;
  String? id;
  int? v;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        productName: json["productName"],
        category: json["category"],
        productShortDescription: json["productShortDescription"],
        productDescription: json["productDescription"],
        productPrice: json["productPrice"]?.toDouble(),
        productSalePrice: json["productSalePrice"]?.toDouble(),
        productImage: json["productImage"],
        productSku: json["productSKU"],
        productType: json["productType"],
        stockStatus: json["stockStatus"],
        relatedProduct: json["relatedProduct"] == null
            ? []
            : List<dynamic>.from(json["relatedProduct"]!.map((x) => x)),
        id: json["_id"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "productName": productName,
        "category": category,
        "productShortDescription": productShortDescription,
        "productDescription": productDescription,
        "productPrice": productPrice,
        "productSalePrice": productSalePrice,
        "productImage": productImage,
        "productSKU": productSku,
        "productType": productType,
        "stockStatus": stockStatus,
        "relatedProduct": relatedProduct == null
            ? []
            : List<dynamic>.from(relatedProduct!.map((x) => x)),
        "_id": id,
        "__v": v,
      };
}
