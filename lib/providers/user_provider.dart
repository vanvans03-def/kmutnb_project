// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable

import 'package:kmutnb_project/models/user.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    id: '',
    fullName: '',
    email: '',
    token: '',
    password: '',
    type: '',
    address: '',
    phoneNumber: '',
    cart: [],
    image: '',
  );

  User get user => _user;

  void setUser(Map<String, dynamic> userData) {
    _user = User.fromMap(userData['data']);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }

  void clearUserData() {
    _user = User(
      id: '',
      fullName: '',
      email: '',
      token: '',
      password: '',
      type: '',
      address: '',
      phoneNumber: '',
      cart: [],
      image: '',
    );
    notifyListeners();
  }
}
