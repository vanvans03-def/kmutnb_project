import 'package:flutter/material.dart';

import '../../../models/product.dart';

class SearchProduct extends StatelessWidget {
  final Product product;
  const SearchProduct({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Image.network(
                product.productImage[0],
                fit: BoxFit.fitHeight,
                height: 135,
                width: 135,
              ),
            ],
          ),
        )
      ],
    );
  }
}
