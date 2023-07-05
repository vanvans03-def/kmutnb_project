import 'dart:convert';

import 'package:kmutnb_project/models/product.dart';

class Order {
  final String id;
  final List<OrderItem> products;
  final double totalPrice;
  final String address;
  final String userId;
  final int orderedAt;
  final int status;
  final String image;
  final String deliveryType;

  Order({
    required this.id,
    required this.products,
    required this.totalPrice,
    required this.address,
    required this.userId,
    required this.orderedAt,
    required this.status,
    required this.image,
    required this.deliveryType,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'products': products.map((x) => x.toMap()).toList(),
      'totalPrice': totalPrice,
      'address': address,
      'userId': userId,
      'orderedAt': orderedAt,
      'status': status,
      'image': image,
      'deliveryType': deliveryType,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['_id'] ?? '',
      products: List<OrderItem>.from(
        map['products']?.map((x) => OrderItem.fromMap(x)),
      ),
      image: map['image'] ?? '',
      totalPrice: map['totalPrice']?.toDouble() ?? 0.0,
      address: map['address'] ?? '',
      userId: map['userId'] ?? '',
      orderedAt: map['orderedAt']?.toInt() ?? 0,
      status: map['status']?.toInt() ?? 0,
      deliveryType: map['deliveryType'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));
}

class OrderItem {
  final Product product;
  final String productSKU;
  final int statusProductOrder;

  OrderItem({
    required this.product,
    required this.productSKU,
    required this.statusProductOrder,
  });

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'productSKU': productSKU,
      'statusProductOrder': statusProductOrder,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      product: Product.fromMap(map['product']),
      productSKU: map['productSKU'] ?? '',
      statusProductOrder: map['statusProductOrder']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderItem.fromJson(String source) =>
      OrderItem.fromMap(json.decode(source));
}
