import 'dart:convert';

class OrderStore {
  final String id;
  final List<OrderItem> products;
  final double totalPrice;
  final String address;
  final String userId;
  final int orderedAt;
  final int status;

  OrderStore({
    required this.id,
    required this.products,
    required this.totalPrice,
    required this.address,
    required this.userId,
    required this.orderedAt,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'products': products.map((x) => x.toMap()).toList(),
      'totalPrice': totalPrice,
      'address': address,
      'userId': userId,
      'orderedAt': orderedAt,
      'status': status,
    };
  }

  factory OrderStore.fromMap(Map<String, dynamic> map) {
    return OrderStore(
      id: map['_id'] ?? '',
      products: List<OrderItem>.from(
        map['products']?.map((x) => OrderItem.fromMap(x)),
      ),
      totalPrice: map['totalPrice']?.toDouble() ?? 0.0,
      address: map['address'] ?? '',
      userId: map['userId'] ?? '',
      orderedAt: map['orderedAt']?.toInt() ?? 0,
      status: map['status']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderStore.fromJson(String source) =>
      OrderStore.fromMap(json.decode(source));
}

class OrderItem {
  final String id;
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
  final String storeId;
  final List<dynamic> ratings;
  final String productQuantity;
  final int statusProductOrder;

  OrderItem({
    required this.id,
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
    required this.storeId,
    required this.ratings,
    required this.productQuantity,
    required this.statusProductOrder,
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
      'storeId': storeId,
      'ratings': ratings,
      'productQuantity': productQuantity,
      'statusProductOrder': statusProductOrder,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['_id'] ?? '',
      productName: map['productName'] ?? '',
      category: map['category'] ?? '',
      productShortDescription: map['productShortDescription'] ?? '',
      productDescription: map['productDescription'] ?? '',
      productPrice: map['productPrice']?.toDouble() ?? 0.0,
      productSalePrice: map['productSalePrice'] ?? '',
      productImage: List<String>.from(map['productImage'] ?? []),
      productSKU: map['productSKU'] ?? '',
      productType: map['productType'] ?? '',
      stockStatus: map['stockStatus'] ?? '',
      storeId: map['storeId'] ?? '',
      ratings: List<dynamic>.from(map['ratings'] ?? []),
      productQuantity: map['productQuantity'] ?? '',
      statusProductOrder: map['statusProductOrder']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderItem.fromJson(String source) =>
      OrderItem.fromMap(json.decode(source));
}
