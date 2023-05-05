import 'package:flutter/material.dart';
import 'package:kmutnb_project/providers/product_list_provider.dart';
import 'package:kmutnb_project/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../../models/product.dart';
import '../../address/screens/addres_screen.dart';
import '../../product_details/services/product_details_service.dart';

class CartSubtotal extends StatelessWidget {
  const CartSubtotal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    double sum = 0;
    user.cart
        .map((e) => sum += e['quantity'] *
            double.parse(e['product']['productPrice'].toString()))
        .toList();

    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          const Text(
            'Subtotal ',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Text(
            '\฿ $sum',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
