import 'dart:convert';

class UserData {
  final String userId;
  final String fullName;
  final String email;
  final String image;
  final String type;
  final String phoneNumber;
  final String address;

  UserData({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.type,
    required this.phoneNumber,
    required this.address,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': userId,
      'fullName': fullName,
      'email': email,
      'type': type,
      'address': address,
      'phoneNumber': phoneNumber,
      'image': image,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      image: map['image'] ?? '',
      userId: map['userId'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      type: map['type'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      address: map['address'] ?? '',
    );
  }

  factory UserData.fromJson(Map<String, dynamic> map) => UserData.fromMap(map);

  String toJson() => json.encode(toMap());
}
