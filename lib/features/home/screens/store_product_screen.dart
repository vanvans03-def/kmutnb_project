import 'package:flutter/material.dart';

import '../../../constants/global_variables.dart';
import '../../../models/category.dart';
import '../../../models/product.dart';
import '../../../models/store.dart';
import '../../account/widgets/single_product.dart';
import '../../admin/screens/store_category_screen.dart';
import '../../admin/services/admin_service.dart';
import '../../product_details/screens/product_deatails_screen.dart';
import '../../product_details/services/product_details_service.dart';

class StoreProductScreen extends StatefulWidget {
  final Store store;
  const StoreProductScreen({super.key, required this.store});

  @override
  State<StoreProductScreen> createState() => _StoreProductScreenState();
}

final AdminService adminService = AdminService();

int selectedCategoryIndex = 0;
List<Product>? products = [];
String categoryId = '';
List<Category> categories = [];

class _StoreProductScreenState extends State<StoreProductScreen> {
  @override
  void initState() {
    super.initState();
    _getCategories();
    fetchAllProductsUser();
  }

  void _getCategories() async {
    categories = await adminService.fetchAllCategory(context);

    setState(() {});
  }

  void navigateToCategoryPage(BuildContext context, String categoryId) {
    Navigator.pushNamed(
      context,
      StoreCategoryScreen.routeName,
      arguments: categoryId,
    );
  }

  void navigateToProductDetails(Product product) {
    Navigator.pushNamed(
      context,
      ProductDetailScreen.routeName,
      arguments: product,
    );
  }

  fetchAllProductsUser() async {
    products = await adminService.fetchAllProductUser(
      context: context,
      storeId: widget.store.storeId,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          title: Text('ร้าน ${widget.store.storeName} '),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // background image and bottom contents
          Column(
            children: <Widget>[
              // ignore: unrelated_type_equality_checks
              if (widget.store.banner == "") ...[
                Container(
                  height: 80.0,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/fruitbanner.PNG'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ] else ...[
                Container(
                  height: 80.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.store.banner),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
//this content
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Scaffold(
                    body: Container(
                      margin: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 70,
                            child: ListView.builder(
                              itemCount: categories.length,
                              itemExtent: 70,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () => navigateToCategoryPage(
                                      context, categories[index].categoryId),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 10),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Image.network(
                                            categories[index].categoryImage,
                                            fit: BoxFit.cover,
                                            height: 40,
                                            width: 40,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        categories[index].categoryName,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: OrientationBuilder(
                                builder: (context, orientation) {
                                  return GridView.builder(
                                    itemCount: products!.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          orientation == Orientation.portrait
                                              ? 2
                                              : 4,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio:
                                          orientation == Orientation.portrait
                                              ? 0.71
                                              : 0.56,
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    itemBuilder: (context, index) {
                                      final productData = products![index];
                                      String nameCategoryOfProduct = '';
                                      for (int i = 0;
                                          i < categories.length;
                                          i++) {
                                        if (productData.category ==
                                            categories[i].categoryId) {
                                          nameCategoryOfProduct =
                                              categories[i].categoryName;
                                        }
                                      }

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                navigateToProductDetails(
                                                    productData);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: SingleProduct(
                                                    image: productData
                                                        .productImage[0],
                                                    productName:
                                                        productData.productName,
                                                    productPrice: productData
                                                        .productPrice
                                                        .toString(),
                                                    categoryName:
                                                        nameCategoryOfProduct,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          // Profile image
          Positioned(
            top: 16.0,
            child: Container(
              child: widget.store.storeImage == ""
                  ? CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.blueGrey,
                      child: Image.asset(
                        "assets/images/online2.png",
                        color: Color.fromRGBO(255, 255, 255, 1),
                        height: 50,
                        width: 50,
                      ),
                    )
                  : CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                        widget.store.storeImage,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
