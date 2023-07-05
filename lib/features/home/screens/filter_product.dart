import 'package:flutter/material.dart';

import '../../../common/widgets/stars.dart';
import '../../../constants/global_variables.dart';
import '../../../models/product.dart';
import '../../../models/productprice.dart';
import '../../admin/services/admin_service.dart';
import '../../product_details/screens/product_deatails_screen.dart';

class FilterProduct extends StatefulWidget {
  final List<Product> products;

  const FilterProduct({Key? key, required this.products}) : super(key: key);

  @override
  _FilterProductState createState() => _FilterProductState();
}

class _FilterProductState extends State<FilterProduct> {
  late Future<List<ProductPrice>> _productPricesFuture;
  List<ProductPrice> _productPrices = [];

  @override
  void initState() {
    super.initState();
    _productPricesFuture = _getProductprices();
  }

  Future<List<ProductPrice>> _getProductprices() async {
    final AdminService adminServices = AdminService();
    return await adminServices.fetchAllProductprice(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          title: const Text('Filter Product Screen'),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<ProductPrice>>(
        future: _productPricesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            _productPrices = snapshot.data!;
            return ListView.builder(
              itemCount: widget.products.length,
              itemBuilder: (context, index) {
                final product = widget.products[index];

                String mocPrice = '';
                for (int i = 0; i < _productPrices.length; i++) {
                  if (_productPrices[i].productId == product.productSalePrice) {
                    mocPrice = _productPrices[i].priceMax.toString();
                  }
                }

                double totalRating = 0;
                for (int i = 0; i < product.rating!.length; i++) {
                  totalRating += product.rating![i].rating;
                }
                double avgRating = 0;
                if (totalRating != 0) {
                  avgRating = totalRating / product.rating!.length;
                }

                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          ProductDetailScreen.routeName,
                          arguments: product,
                        );
                      },
                      child: Container(
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
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
                                  padding:
                                      const EdgeInsets.only(left: 10, top: 5),
                                  child: Stars(rating: avgRating),
                                ),
                                Container(
                                  width: 200,
                                  padding:
                                      const EdgeInsets.only(left: 10, top: 5),
                                  child: Text(
                                    '฿${product.productPrice}',
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
                                    'มีสินค้าพร้อมส่ง',
                                  ),
                                ),
                                if (mocPrice != '') ...[
                                  Align(
                                    alignment: FractionalOffset.topLeft,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 4),
                                      margin:
                                          const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'ราคาตลาดวันนี้ $mocPrice ${product.productType}',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      height: 2,
                      thickness: 1,
                      indent: 0,
                      endIndent: 0,
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
