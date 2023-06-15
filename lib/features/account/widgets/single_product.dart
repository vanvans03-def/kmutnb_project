// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:image_card/image_card.dart';

class SingleProduct extends StatelessWidget {
  String image;
  String productName;
  String productPrice;
  String categoryName;

  SingleProduct({
    Key? key,
    required this.image,
    required this.productName,
    required this.productPrice,
    required this.categoryName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: TransparentImageCard(
            height: 300,
            width: 300,
            imageProvider: NetworkImage(image),
            tags: _tag(label: categoryName),
            title: _title(color: Colors.white, productName: productName),
            description:
                _content(color: Colors.white, productPrice: productPrice),
          ),
        ),
      ),
    );
  }

  List<Widget> _tag({required String label}) {
    Color tagColor;

    if (label == "Fruit") {
      tagColor = Colors.blue;
    } else if (label == "Dry Friut") {
      tagColor = Colors.red;
    } else if (label == "Vegetable") {
      tagColor = Colors.green;
    } else {
      tagColor = Colors.blue; // Default color for other cases
    }

    return [
      GestureDetector(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: tagColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    ];
  }

  Widget _title({required Color color, required String productName}) {
    return Text(
      productName,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );
  }

  Widget _content({required Color color, required String productPrice}) {
    return Text(
      '$productPrice ฿',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
    );
  }
}
