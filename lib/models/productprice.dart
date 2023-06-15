import 'dart:convert';

class ProductPrice {
  final String productId;
  final String productName;
  final String categoryName;
  final String groupName;
  final String unit;
  final DateTime date;
  final double priceMin;
  final double priceMax;

  ProductPrice({
    required this.productId,
    required this.productName,
    required this.categoryName,
    required this.groupName,
    required this.unit,
    required this.date,
    required this.priceMin,
    required this.priceMax,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'categoryName': categoryName,
      'groupName': groupName,
      'unit': unit,
      'date': date.toIso8601String(),
      'priceMin': priceMin,
      'priceMax': priceMax,
    };
  }

  factory ProductPrice.fromMap(Map<String, dynamic> map) {
    return ProductPrice(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      categoryName: map['categoryName'] ?? '',
      groupName: map['groupName'] ?? '',
      unit: map['unit'] ?? '',
      date: DateTime.parse(map['date']),
      priceMin: map['priceMin']?.toDouble() ?? 0.0,
      priceMax: map['priceMax']?.toDouble() ?? 0.0,
    );
  }

  factory ProductPrice.fromJson(String json) =>
      ProductPrice.fromMap(jsonDecode(json));

  String toJson() => jsonEncode(toMap());
}
