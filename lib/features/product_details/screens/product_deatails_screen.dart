import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kmutnb_project/common/widgets/customer_button.dart';
import 'package:kmutnb_project/features/auth/widgets/constants.dart';
import 'package:kmutnb_project/features/product_details/services/product_details_service.dart';
import 'package:kmutnb_project/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/stars.dart';
import '../../../constants/global_variables.dart';
import '../../../models/product.dart';
import '../../../models/productprice.dart';
import '../../admin/services/admin_service.dart';
import '../../cart/screens/cart_screen.dart';
import '../../search/screens/search_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  static const String routeName = "/product-details";
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductDetailsServices productDetailsServices =
      ProductDetailsServices();
  double myRating = 0;
  double avgRating = 0;
  String mocPrice = '';

  @override
  void initState() {
    super.initState();
    _getProductprices();

    double totalRating = 0;
    for (int i = 0; i < widget.product.rating!.length; i++) {
      totalRating += widget.product.rating![i].rating;
      if (widget.product.rating![i].userId ==
          Provider.of<UserProvider>(context, listen: false).user.id) {
        myRating = widget.product.rating![i].rating;
      }
    }

    if (widget.product.rating!.isNotEmpty) {
      avgRating = totalRating / widget.product.rating!.length;
    }
    setState(() {}); // อัปเดตค่า avgRating
  }

  final AdminService adminServices = AdminService();
  List<ProductPrice> productpricesList = [];
  void _getProductprices() async {
    productpricesList = await adminServices.fetchAllProductprice(context);

    setState(() {
      for (int i = 0; i < productpricesList.length; i++) {
        if (productpricesList[i].productId == widget.product.productSalePrice) {
          mocPrice = productpricesList[i].priceMax.toString();
        }
      }
    });
  }

  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  void addToCart() {
    productDetailsServices.addToCart(
      context: context,
      product: widget.product,
    );
  }

  void addToCartAndGo() {
    productDetailsServices.addToCart(
      context: context,
      product: widget.product,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CartScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
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
              Container(
                color: Colors.transparent,
                height: 42,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Icon(Icons.mic, color: Colors.black, size: 25),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.product.productName,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor),
                  ),
                  Stars(
                    rating: avgRating,
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              if (mocPrice != '') ...[
                Align(
                  alignment: FractionalOffset.topLeft,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    margin: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'ราคาตลาดวันนี้ $mocPrice฿/กก.',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
              CarouselSlider(
                items: widget.product.productImage.map(
                  (i) {
                    return Builder(
                      builder: (BuildContext context) => Image.network(
                        i,
                        fit: BoxFit.contain,
                        height: 300,
                      ),
                    );
                  },
                ).toList(),
                options: CarouselOptions(
                  viewportFraction: 1,
                  height: 300,
                ),
              ),
            ],
          ),
          Container(
            color: Colors.black12,
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: RichText(
              text: TextSpan(
                text: 'ราคา: ',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: '${widget.product.productPrice}฿/กก',
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.product.productShortDescription),
          ),
          Container(
            color: Colors.black12,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.product.productDescription),
          ),
          Container(
            color: Colors.black12,
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: CustomButton(
              text: 'ซื้อสินค้า',
              onTap: addToCartAndGo,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(10),
            child: CustomButton(
              text: 'กดใส่ตะกร้า',
              onTap: addToCart,
              color: const Color.fromRGBO(254, 216, 19, 1),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            color: Colors.black12,
            height: 5,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              'คะแนนสินค้า',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          RatingBar.builder(
            initialRating: myRating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: GlobalVariables.secondaryColor,
            ),
            onRatingUpdate: (rating) {
              productDetailsServices.rateProduct(
                context: context,
                product: widget.product,
                rating: rating,
              );
            },
          )
        ],
      )),
    );
  }
}
