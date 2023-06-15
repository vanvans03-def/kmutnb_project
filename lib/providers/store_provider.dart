import 'package:kmutnb_project/models/store.dart';
import 'package:flutter/material.dart';

class StoreProvider extends ChangeNotifier {
  Store _store = Store(
    user: '',
    banner: '',
    phone: '',
    storeDescription: '',
    storeId: '',
    storeImage: '',
    storeName: '',
    storeStatus: '',
    storeShortDescription: '',
    province: '',
    idcardImage: '',
    idcardNo: '',
  );

  Store get store => _store;

  void setStore(dynamic storeData) {
    final data = storeData is List ? storeData.first : storeData;
    _store = Store.fromMap(data);

    notifyListeners();
  }

  void setStorerFromModel(Store store) {
    _store = store;
    notifyListeners();
  }
}
