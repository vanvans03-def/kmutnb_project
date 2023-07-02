import 'package:flutter/material.dart';
import 'package:image_card/image_card.dart';
import 'package:kmutnb_project/features/auth/widgets/constants.dart';
import 'package:kmutnb_project/features/home/screens/store_category_screen.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/stars.dart';
import '../../../constants/global_variables.dart';
import '../../../models/category.dart';
import '../../../models/product.dart';
import '../../../models/productprice.dart';
import '../../../models/store.dart';
import '../../../providers/user_provider.dart';
import '../../account/widgets/single_product.dart';
import 'package:badges/badges.dart' as badge;
import '../../admin/services/admin_service.dart';
import '../../cart/screens/cart_screen.dart';
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
String mocPrice = '';

class _StoreProductScreenState extends State<StoreProductScreen> {
  @override
  void initState() {
    super.initState();
    _getCategories();
    fetchAllProductsUser();
    _getProductprices();
  }

  void _getCategories() async {
    categories = await adminService.fetchAllCategory(context);

    setState(() {});
  }

  List<ProductPrice> productpricesList = [];
  void _getProductprices() async {
    productpricesList = await adminService.fetchAllProductprice(context);
  }

  void navigateToCategoryPage(
      BuildContext context, String categoryId, Store store) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StoreCategoryScreen(
          category: categoryId,
          store: store,
        ),
      ),
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
    final userCartLen = context.watch<UserProvider>().user.cart.length;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          title: Row(
            children: [
              Expanded(
                child: Text('ร้าน ${widget.store.storeName}'),
              ),
              InkWell(
                child: Container(
                  width: 35,
                  decoration: BoxDecoration(),
                  child: badge.Badge(
                    position: badge.BadgePosition.topEnd(top: -12, end: -2),
                    badgeContent: Text(userCartLen.toString()),
                    //badgeColor: Colors.white,
                    badgeStyle: badge.BadgeStyle(
                      badgeColor: Colors.blue.shade400,
                      padding: EdgeInsets.all(5),
                    ),
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartScreen()),
                  );
                },
              ),
            ],
          ),
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
                                      context,
                                      categories[index].categoryId,
                                      widget.store),
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
                                              ? 0.66
                                              : 0.56,
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    itemBuilder: (context, index) {
                                      final productData = products![index];
                                      double totalRating = 0.0;
                                      double avgRating = 0.0;
                                      // ignore: unused_local_variable
                                      double rateAllProduct = 0.0;

                                      final productA = productData;

                                      for (int j = 0;
                                          j < productA.rating!.length;
                                          j++) {
                                        totalRating +=
                                            productA.rating![j].rating;
                                      }
                                      if (productA.rating!.isNotEmpty) {
                                        avgRating = totalRating /
                                            productA.rating!.length;
                                        rateAllProduct += avgRating;
                                      } else {
                                        avgRating = 0.0;
                                      }
                                      mocPrice = '';
                                      for (int i = 0;
                                          i < productpricesList.length;
                                          i++) {
                                        if (productpricesList[i].productId ==
                                            productData.productSalePrice) {
                                          mocPrice = productpricesList[i]
                                              .priceMax
                                              .toString();
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
                                                  child: SingleOrderProduct(
                                                    image: productData
                                                        .productImage[0],
                                                    productName:
                                                        productData.productName,
                                                    price: productData
                                                        .productPrice
                                                        .toString(),
                                                    productPriceList:
                                                        productpricesList,
                                                    ratings: avgRating,
                                                    salePrice: productData
                                                        .productSalePrice,
                                                    mocPrice: mocPrice,
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
                      radius: 37,
                      backgroundColor: kPrimaryColor,
                      child: CircleAvatar(
                        radius: 34,
                        backgroundImage: NetworkImage(
                          widget.store.storeImage,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class SingleOrderProduct extends StatelessWidget {
  final String image;
  final String price;
  final String? salePrice;
  final String productName;
  final double ratings;
  final String mocPrice;
  final List<ProductPrice> productPriceList;

  const SingleOrderProduct({
    Key? key,
    required this.image,
    required this.price,
    this.salePrice,
    required this.productPriceList,
    required this.productName,
    required this.ratings,
    required this.mocPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Stack(
        children: [
          TransparentImageCard(
            width: 200,
            height: 300,
            imageProvider: NetworkImage(image),
            title: _title(color: Colors.white, productName: productName),
            description: _content(color: Colors.white, price: price),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Visibility(
              visible: mocPrice != '',
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'ราคาตลาดวันนี้ $mocPrice฿/กก.',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: 200,
              padding: const EdgeInsets.all(8),
              child: Stars(rating: ratings),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tag(String label, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }

  Widget _content({required Color color, required String price}) {
    return Text(
      "$price฿/กก.",
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
          color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
    );
  }

  Widget _title({Color? color, required String productName}) {
    return Text(
      productName,
      maxLines: 2,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }
}
