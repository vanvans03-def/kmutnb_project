import 'package:flutter/material.dart';
import 'package:image_card/image_card.dart';

class SingleOrderProduct extends StatelessWidget {
  final String image;
  final String date;
  const SingleOrderProduct({Key? key, required this.image, required this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: TransparentImageCard(
        width: 200,
        height: 200,
        imageProvider: NetworkImage(image),
        tags: [_tag('Order', () {})],
        // title: _title(color: Colors.white),
        description: _content(color: Colors.white, date: date),
      ),
    );
  }

  Widget _tag(String label, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _content({required Color color, required String date}) {
    return Text(
      date,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 10,
      ),
    );
  }
}
