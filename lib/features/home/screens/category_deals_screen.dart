import 'package:flutter/material.dart';
import 'package:image_card/image_card.dart';
import 'package:kmutnb_project/common/widgets/loader.dart';
import 'package:kmutnb_project/features/address/services/address_services.dart';
import 'package:kmutnb_project/features/admin/services/admin_service.dart';
import 'package:kmutnb_project/features/home/screens/store_product_screen.dart';
import 'package:kmutnb_project/features/home/services/home_service.dart';
import 'package:kmutnb_project/features/product_details/screens/product_deatails_screen.dart';
import 'package:badges/badges.dart' as badge;
import 'package:provider/provider.dart';

import '../../../common/widgets/stars.dart';
import '../../../constants/global_variables.dart';
import '../../../models/category.dart';
import '../../../models/product.dart';
import '../../../models/productprice.dart';
import '../../../models/store.dart';
import '../../../providers/user_provider.dart';
import '../../cart/screens/cart_screen.dart';
import '../../chat/screens/chat_screen.dart';
import '../../search/screens/search_screen.dart';

class CategoryDealsScreen extends StatefulWidget {
  static const String routeName = '/category-deals';
  final String category;
  const CategoryDealsScreen({Key? key, required this.category})
      : super(key: key);

  @override
  _CategoryDealsScreenState createState() => _CategoryDealsScreenState();
}

class _CategoryDealsScreenState extends State<CategoryDealsScreen> {
  List<Product>? productList;
  List<Store>? storeList;
  String categoryName = '';
  String mocPrice = '';
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

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  fetchCategory() async {
    String categoryId = widget.category;
    Category category = await addressService.getCategory(
      context: context,
      categoryId: categoryId,
    );
    categoryName = category.categoryName;
    List<Product> products = await homeService.fetchAllProduct(context);
    storeList = await homeService.fetchAllStore(context);

    // Filter the products that match the desired category ID
    productList =
        products.where((product) => product.category == categoryId).toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userCartLen = context.watch<UserProvider>().user.cart.length;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  margin: const EdgeInsets.only(left: 15),
                  child: Material(
                    borderRadius: BorderRadius.circular(7),
                    elevation: 1,
                    child: TextFormField(
                      onFieldSubmitted: navigateToSearchScreen,
                      decoration: InputDecoration(
                        prefixIcon: InkWell(
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.only(
                              left: 6,
                            ),
                            child: Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 23,
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.only(top: 10),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black38,
                            width: 1,
                          ),
                        ),
                        hintText: 'Search',
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                child: Container(
                  width: 35,
                  decoration: const BoxDecoration(),
                  child: badge.Badge(
                    position: badge.BadgePosition.topEnd(top: -12, end: -2),
                    badgeContent: Text(userCartLen.toString()),
                    badgeStyle: badge.BadgeStyle(
                      badgeColor: Colors.blue.shade400,
                      padding: const EdgeInsets.all(5),
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
        ),
      ),
      body: productList == null
          ? const Loader()
          : Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.topLeft,
                  child: Text(
                    'สินค้าในหมวดหมู่ $categoryName',
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: storeList!.length,
                    itemBuilder: (context, storeIndex) {
                      double totalRating = 0.0;
                      double avgRating = 0.0;
                      // ignore: unused_local_variable
                      double rateAllProduct = 0.0;
                      for (int i = 0; i < productList!.length; i++) {
                        final productA = productList![i];

                        for (int j = 0; j < productA.rating!.length; j++) {
                          totalRating += productA.rating![j].rating;
                        }
                        if (productA.rating!.isNotEmpty) {
                          avgRating = totalRating / productA.rating!.length;
                          rateAllProduct += avgRating;
                        }
                      }
                      final store = storeList![storeIndex];
                      List<Product> productsInStore = productList!
                          .where((product) => product.storeId == store.storeId)
                          .toList();

                      if (store.storeStatus == '0' || productsInStore.isEmpty) {
                        // Skip hidden stores or stores without products
                        return const SizedBox.shrink();
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => StoreProductScreen(
                                        store: store,
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    if (store.storeImage == "") ...[
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 15, top: 10, bottom: 10),
                                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.blueGrey,
                                          child: Image.asset(
                                            "assets/images/online2.png",
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1),
                                            height: 25,
                                            width: 25,
                                          ),
                                        ),
                                      ),
                                    ] else ...[
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 15, top: 10, bottom: 10),
                                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundImage: NetworkImage(
                                            store.storeImage,
                                          ),
                                        ),
                                      ),
                                    ],
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 15, top: 10, bottom: 10),
                                      child: Text(
                                        'ร้าน: ${store.storeName}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                color: Colors.transparent,
                                height: 42,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.chat,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      ChatScreen.routeName,
                                      arguments: {
                                        'receiverId': store.user,
                                        'chatName': store.storeName,
                                        'senderId': userProvider.user.id,
                                        'image': store.storeImage,
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 250,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.only(left: 15),
                              itemCount: productsInStore.length,
                              itemBuilder: (context, index) {
                                final product = productsInStore[index];
                                double avgRating = 0;
                                double totalRating = 0;
                                for (int i = 0;
                                    i < product.rating!.length;
                                    i++) {
                                  totalRating += product.rating![i].rating;
                                }
                                if (product.rating!.isNotEmpty) {
                                  avgRating =
                                      totalRating / product.rating!.length;
                                }
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      ProductDetailScreen.routeName,
                                      arguments: product,
                                    );
                                  },
                                  child: SizedBox(
                                    width: 200,
                                    child: Column(
                                      children: [
                                        SingleOrderProduct(
                                          image: product.productImage[0],
                                          price:
                                              product.productPrice.toString(),
                                          salePrice: product.productSalePrice,
                                          productPriceList: productpricesList,
                                          productName: product.productName,
                                          ratings: avgRating,
                                          productType: product.productType,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
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
  final List<ProductPrice> productPriceList;
  final String productType;

  const SingleOrderProduct({
    Key? key,
    required this.image,
    required this.price,
    this.salePrice,
    required this.productPriceList,
    required this.productName,
    required this.ratings,
    required this.productType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String mocPrice = '';

    void _getSalePrice() {
      if (salePrice != null && salePrice != '0') {
        for (int i = 0; i < productPriceList.length; i++) {
          if (productPriceList[i].productId == salePrice) {
            mocPrice = productPriceList[i].priceMax.toString();
          }
        }
      }
    }

    _getSalePrice();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Stack(
        children: [
          TransparentImageCard(
            width: 200,
            height: 200,
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
                  'ราคาตลาดวันนี้ $mocPrice $productType',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
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
      "$price $productType",
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
