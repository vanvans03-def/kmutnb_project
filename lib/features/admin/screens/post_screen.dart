import 'package:flutter/material.dart';
import 'package:kmutnb_project/common/widgets/loader.dart';
import 'package:kmutnb_project/features/admin/screens/add_products_screen.dart';
import 'package:kmutnb_project/features/admin/services/admin_service.dart';

import '../../../models/product.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<Product>? products = [];
  final AdminService adminService = AdminService();
  @override
  void initState() async {
    super.initState();
    fetchAllProducts();
  }

  fetchAllProducts() async {
    await adminService.fetchAllProduct(context);
  }

  void navigateToAddproduct() {
    Navigator.pushNamed(context, AddProductScreen.routeName);
    setState(() {}); //6.02
  }

  @override
  Widget build(BuildContext context) {
    return products == null
        ? const Loader()
        : Scaffold(
            body: const Center(
              child: Text('Products'),
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: navigateToAddproduct,
              tooltip: 'Add a Product',
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
