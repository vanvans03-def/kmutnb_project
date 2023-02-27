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

  Map<String, dynamic> toMap() {
    return {
      'categoryName': categoryName,
      'categoryImage': categoryImage,
      'categoryId': categoryId,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      categoryName: map['categoryName'] ?? '',
      categoryImage: map['categoryImage'] ?? '',
      categoryId: map['categoryId'] ?? '',
    );
  }

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}
