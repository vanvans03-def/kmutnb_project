import 'dart:convert';

class User {
  final String id;
  final String fullName;
  final String email;
  final String token;
  final String password;
  final String type;
  final String phoneNumber;
  final String address;
  final List<dynamic> cart;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.token,
    required this.password,
    required this.type,
    required this.phoneNumber,
    required this.address,
    required this.cart,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'token': token,
      'password': password,
      'type': type,
      'address': address,
      'phoneNumber': phoneNumber,
      'cart': cart,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      token: map['token'] ?? '',
      password: map['password'] ?? '',
      type: map['type'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      address: map['address'] ?? '',
      cart: (map['cart'] != null)
          ? List<Map<String, dynamic>>.from(
              map['cart']?.map(
                    (x) => Map<String, dynamic>.from(x),
                  ) ??
                  [],
            )
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source)['data']);

  User copyWith({
    String? id,
    String? fullName,
    String? email,
    String? password,
    String? address,
    String? type,
    String? phoneNumber,
    String? token,
    List<dynamic>? cart,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      address: address ?? this.address,
      type: type ?? this.type,
      phoneNumber: type ?? this.type,
      token: token ?? this.token,
      cart: cart ?? this.cart,
    );
  }
}
