import 'package:flutter/material.dart';
import 'package:image_card/image_card.dart';
import 'package:kmutnb_project/common/widgets/loader.dart';
import 'package:kmutnb_project/features/account/widgets/single_product.dart';
import 'package:kmutnb_project/features/admin/screens/add_products_screen.dart';
import 'package:kmutnb_project/features/admin/screens/edit_products_screen.dart';
import 'package:kmutnb_project/features/home/screens/store_product_screen.dart';
import 'package:kmutnb_project/models/category.dart';
import 'package:kmutnb_project/models/product.dart';
import '../../../common/widgets/stars.dart';
import '../../../models/productprice.dart';
import '../../../models/store.dart';
import '../../address/services/address_services.dart';
import '../../admin/services/admin_service.dart';
import '../../home/services/home_service.dart';

class StoreCategoryScreen extends StatefulWidget {
  static const String routeName = '/store-category';
  final String category;
  final Store store;

  const StoreCategoryScreen(
      {Key? key, required this.category, required this.store})
      : super(key: key);

  @override
  _StoreCategoryScreenState createState() => _StoreCategoryScreenState();
}

class _StoreCategoryScreenState extends State<StoreCategoryScreen> {
  List<Product>? productList;
  List<Category> categories = [];
  String categoryName = '';
  final HomeService homeService = HomeService();
  final AddressService addressService = AddressService();

  @override
  void initState() {
    super.initState();
    fetchCategory();
    _getProductprices();
  }

  final AdminService adminServices = AdminService();
  List<ProductPrice> productpricesList = [];
  void _getProductprices() async {
    productpricesList = await adminServices.fetchAllProductprice(context);

    setState(() {});
  }

  void navigateToAddproduct() {
    Navigator.pushNamed(context, AddProductScreen.routeName);
  }

  fetchCategory() async {
    String categoryId = widget.category;
    Category category = await addressService.getCategory(
      context: context,
      categoryId: categoryId,
    );
    categoryName = category.categoryName;

    List<Product> products = await adminService.fetchAllProductUser(
      context: context,
      storeId: widget.store.storeId,
    );

    // Filter the products that match the desired category ID
    productList =
        products.where((product) => product.category == categoryId).toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'สินค้าในหมวดหมู่ $categoryName',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: productList == null
            ? const Loader()
            : Scaffold(
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
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Center(
                          child: OrientationBuilder(
                            builder: (context, orientation) {
                              return GridView.builder(
                                itemCount: productList!.length,
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
                                          ? 0.62
                                          : 0.56,
                                ),
                                padding: const EdgeInsets.all(10),
                                itemBuilder: (context, index) {
                                  final productData = productList![index];
                                  String mocPrice = '';
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
                                  double totalRating = 0.0;
                                  double avgRating = 0.0;
                                  // ignore: unused_local_variable
                                  double rateAllProduct = 0.0;

                                  final productA = productData;

                                  for (int j = 0;
                                      j < productA.rating!.length;
                                      j++) {
                                    totalRating += productA.rating![j].rating;
                                  }
                                  if (productA.rating!.isNotEmpty) {
                                    avgRating =
                                        totalRating / productA.rating!.length;
                                    rateAllProduct += avgRating;
                                  }
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditProductScreen(
                                                  productData: productData,
                                                ),
                                              ),
                                            );
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
                                                image:
                                                    productData.productImage[0],
                                                productName:
                                                    productData.productName,
                                                productPrice: productData
                                                    .productPrice
                                                    .toString(),
                                                categoryName: categoryName,
                                                mocPrice: mocPrice,
                                                avgRating: avgRating,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
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
              ));
  }
}

class SingleProduct extends StatelessWidget {
  String image;
  String productName;
  String productPrice;
  String categoryName;
  String mocPrice;
  double avgRating;

  SingleProduct({
    Key? key,
    required this.image,
    required this.productName,
    required this.productPrice,
    required this.categoryName,
    required this.mocPrice,
    required this.avgRating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: AspectRatio(
          aspectRatio: 1,
          child: Stack(children: [
            ClipRRect(
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
            if (mocPrice != '') ...[
              Align(
                alignment: FractionalOffset.topLeft,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      decoration: BoxDecoration(
                        color: Colors.red,
                      ),
                      child: Text(
                        'ราคาตลาดวันนี้ $mocPrice฿/กก.',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ],
                ),
              )
            ] else ...[
              Align(
                alignment: FractionalOffset.topLeft,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0),
                      ),
                      child: const Text(
                        '',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ],
                ),
              )
            ]
          ])),
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
      Stars(
        rating: avgRating,
      ),
    ];
  }

  Widget _title({required Color color, required String productName}) {
    return Text(
      productName,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
    );
  }

  Widget _content({required Color color, required String productPrice}) {
    return Column(
      children: [
        Text(
          '$productPrice ฿',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
