import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/global_variables.dart';
import 'product.dart';

Future<List<Product>> getProducts() async {
  final response = await http.get(Uri.parse('$uri/api/product'));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    List<Product> products = data.map((e) => Product.fromJson(e)).toList();
    print(products);
    return products;
  } else {
    throw Exception('Failed to load products');
  }
}
