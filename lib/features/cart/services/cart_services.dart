import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';
import '../../../models/product.dart';
import '../../../models/user.dart';
import '../../../providers/user_provider.dart';

class CartService {
  void removeFromCart({
    required BuildContext context,
    required Product product,

    // required String id,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final productId = product.id;
    try {
      http.Response res = await http.delete(
        Uri.parse('$uri/api/remove-cart'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'UserEmail': userProvider.user.email,
          'ProductId': productId,
        }),
      );
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var responseJson = jsonDecode(res.body);
          User user = userProvider.user.copyWith(cart: responseJson['cart']);
          userProvider.setUserFromModel(user);
        },
      );
    } catch (e) {
      //showSnackBar(context, e.toString());
    }
  }
}
