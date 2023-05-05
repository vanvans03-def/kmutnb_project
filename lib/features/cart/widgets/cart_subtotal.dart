import 'package:flutter/material.dart';
import 'package:kmutnb_project/providers/product_list_provider.dart';
import 'package:kmutnb_project/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../../models/product.dart';
import '../../address/screens/addres_screen.dart';
import '../../product_details/services/product_details_service.dart';

class CartSubtotal extends StatefulWidget {
  const CartSubtotal({Key? key}) : super(key: key);

  @override
  _CartSubtotalState createState() => _CartSubtotalState();
}

class _CartSubtotalState extends State<CartSubtotal> {
  final ProductDetailsServices productDetailsServices =
      ProductDetailsServices();
  double _sum = 0.0;

  @override
  void initState() {
    super.initState();
    _calculateSum();
  }

  Future<void> _calculateSum() async {
    final user = context.read<UserProvider>().user;
    final productList = <Product>[];
    print(user.cart[0]);

    double sum2 = 0.0;
    user.cart
        .map((e) => sum2 += e['quantity'] * e['product']['price'] as double)
        .toList();
    print("hello sum $sum2");
    for (int i = 0; i < user.cart.length; i++) {
      String productId = user.cart[i]['product'];
      Product product = await productDetailsServices.findProductId(
          context: context, id: productId);
      int quantity = user.cart[i]['quantity'] as int;
      double productPrice = product.productPrice;

      _updateSum(quantity, productPrice);
    }
  }

  void _updateSum(int quantity, double productPrice) {
    setState(() {
      _sum += quantity * productPrice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          const Text(
            'Subtotal',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Text(
            '\฿ $_sum',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
