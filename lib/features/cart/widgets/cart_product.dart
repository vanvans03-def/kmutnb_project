import 'package:flutter/material.dart';
import 'package:kmutnb_project/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../../models/product.dart';
import '../../product_details/services/product_details_service.dart';

class CartProduct extends StatefulWidget {
  final int index;
  final cart;
  const CartProduct({Key? key, required this.index, required this.cart})
      : super(key: key);

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  Product? product;

  Future<void> getProduct() async {
    final user = context.read<UserProvider>().user;
    final ProductDetailsServices productDetailsServices =
        ProductDetailsServices();
    String productId = user.cart[widget.index]['product'];
    Product productList = await productDetailsServices.findProductId(
        context: context, id: productId);
    //print(productId);
    setState(() {
      product = productList;
    });
  }

  @override
  void initState() {
    super.initState();
    if (context.read<UserProvider>().user.cart.isNotEmpty) {
      getProduct();
    }
  }

  @override
  Widget build(BuildContext context) {
    final productCart = context.watch<UserProvider>().user.cart[widget.index];

    if (product == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Column(
      children: [
        if (product != null)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Image.network(
                  product!.productImage[0],
                  fit: BoxFit.fitWidth,
                  height: 135,
                  width: 135,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 200,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        product!.productName,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        maxLines: 2,
                      ),
                    ),
                    Container(
                      width: 200,
                      padding: const EdgeInsets.only(left: 10, top: 5),
                      child: Text(
                        '\฿ ${product!.productPrice}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                      ),
                    ),
                    Container(
                      width: 200,
                      padding: const EdgeInsets.only(left: 10),
                      child: const Text(
                        'Eligible for FREE Shipping',
                      ),
                    ),
                    Container(
                      width: 200,
                      padding: const EdgeInsets.only(left: 10, top: 5),
                      child: const Text(
                        'In Stock',
                        style: TextStyle(
                          color: Colors.teal,
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
      ],
    );
  }
}
