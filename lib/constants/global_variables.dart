import 'package:flutter/material.dart';

String uri = 'http://192.168.1.159:4000';

class GlobalVariables {
  // COLORS
  static const appBarGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 29, 201, 192),
      Color.fromARGB(255, 125, 221, 216),
    ],
    stops: [0.5, 1.0],
  );
  static const secondaryColor = Color.fromRGBO(255, 153, 0, 1);
  static const backgroundColor = Colors.white;
  static const Color greyBackgroundCOlor = Color(0xffebecee);
  static var selectedNavBarColor = Colors.cyan[800]!;
  static const unselectedNavBarColor = Colors.black87;

  // STATIC IMAGES
  static const List<String> carouselImages = [
    'https://thumbs.dreamstime.com/b/collage-fruits-isolated-white-background-copy-space-fresh-healthy-fruits-berries-collection-collage-fruits-168363403.jpg',
    'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/fruit-shop-banner-ad-design-template-0bb151fb758c9ae788c07409e45314b4_screen.jpg?ts=1566599059',
    'https://img.freepik.com/premium-psd/falling-fruits-berries-banner_88281-2745.jpg?w=2000',
    'https://img.freepik.com/premium-psd/falling-fruits-berries-packaging-design_88281-2142.jpg?w=2000',
    'https://img.freepik.com/premium-photo/flying-fruits-berries-isolated-white-background_88281-1410.jpg?w=2000',
  ];

  static const List<Map<String, String>> categoryImages = [
    {
      'title': 'fruit',
      'image': 'assets/images/fruit.png',
    },
    {
      'title': 'vegetable',
      'image': 'assets/images/organic-food.png',
    },
    {
      'title': 'dry fruit',
      'image': 'assets/images/dried-fruit.png',
    },
  ];
}
