import 'dart:convert';

class Category {
  final String categoryName;
  final String categoryImage;
  final String categoryId;

  Category({
    required this.categoryName,
    required this.categoryImage,
    required this.categoryId,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      categoryName: map['categoryName'] ?? '',
      categoryImage: map['categoryImage'] ?? '',
      categoryId: map['categoryId'] ?? '',
    );
  }

  factory Category.fromJson(dynamic data) {
    if (data is String) {
      final Map<String, dynamic> jsonMap = json.decode(data);
      return Category.fromMap(jsonMap);
    } else if (data is Map<String, dynamic>) {
      return Category.fromMap(data);
    } else {
      throw FormatException('Invalid data format for Category');
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryName': categoryName,
      'categoryImage': categoryImage,
      'categoryId': categoryId,
    };
  }

  String toJson() => json.encode(toMap());
}
