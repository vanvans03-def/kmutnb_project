import 'package:flutter/material.dart';
import 'package:kmutnb_project/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../../models/product.dart';
import '../../product_details/services/product_details_service.dart';

class CartProduct extends StatefulWidget {
  final int index;
  const CartProduct({super.key, required this.index, required cart});
//ส่ง cart มา มี product ID อย่างเดียว ***
  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().user;
    final ProductDetailsServices productDetailsServices =
        ProductDetailsServices();

    Product productList;
    var product;
    Future<void> getProduct() async {
      String productId = user.cart[widget.index]['product'];
      productList = await productDetailsServices.findProductId(
          context: context, id: productId);
      product = productList;
      setState(() {});
    }

    @override
    void initState() {
      super.initState();
      if (user.cart != null && user.cart.isNotEmpty) {
        getProduct();
      }
    }

    final productCart = context.watch<UserProvider>().user.cart[widget.index];

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Image.network(
                product.productImage[0],
                fit: BoxFit.fitWidth,
                height: 135,
                width: 135,
              ),
              Column(
                children: [
                  Container(
                    width: 200,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      product.productName,
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
                      '\฿${product.productPrice}',
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
        )
      ],
    );
  }
}
