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
  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.token,
    required this.password,
    required this.type,
    required this.phoneNumber,
    required this.address,
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
      'phoneNumber': phoneNumber
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
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source)['data']);
}
