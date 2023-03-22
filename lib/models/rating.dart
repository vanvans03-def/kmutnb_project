import 'dart:convert';

class Rating {
  final String userId;
  final double rating;

  Rating(
    this.userId,
    this.rating,
  );

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'userId': userId});
    result.addAll({'rating': rating});

    return result;
  }

  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
      map['userId'] ?? '',
      map['rating']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Rating.fromJson(String source) => Rating.fromMap(json.decode(source));
}
