// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:image_card/image_card.dart';
import 'package:kmutnb_project/features/auth/widgets/constants.dart';
import 'package:kmutnb_project/models/productprice.dart';

import '../../../common/widgets/loader.dart';
import '../../../common/widgets/stars.dart';
import '../../../models/product.dart';
import '../../admin/services/admin_service.dart';
import '../../product_details/screens/product_deatails_screen.dart';
import '../services/home_service.dart';

class DealOfDay extends StatefulWidget {
  const DealOfDay({Key? key}) : super(key: key);

  @override
  State<DealOfDay> createState() => _DealOfDayState();
}

class _DealOfDayState extends State<DealOfDay> {
  List<Product>? productList;
  double mocPrice = 0;
  double topdiscount = 0;
  final HomeService homeService = HomeService();
  final AdminService adminServices = AdminService();
  List<ProductPrice> productpricesList = [];
  double totalRating = 0.0;
  double avgRating = 0.0;
  double rateAllProduct = 0.0;
  @override
  void initState() {
    super.initState();
    _getProductprices();
    getProductDeal();

    setState(() {});
  }

  List mocPrice1 = [];
  Future<void> getProductDeal() async {
    productList = await homeService.fetchProductDeal(context);
    setState(() {
      for (int i = 0; i < productList!.length; i++) {
        if (productList![i].productSalePrice != '0') {
          for (int j = 0; j < productpricesList.length; j++) {
            if (productpricesList[i].productId ==
                productList![i].productSalePrice) {
              mocPrice1[i] = productpricesList[j].priceMax.toString();
            }
          }
        }
      }
    });
  }

  void _getProductprices() async {
    productpricesList = await adminServices.fetchAllProductprice(context);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(left: 10, top: 15),
          child: const Text(
            'สินค้าลดสูงสุดประจำวันนี้',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
        ),
        if (productList == null) Loader(),
        if (productList != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    ProductDetailScreen.routeName,
                    arguments: productList!.first,
                  );
                },
                child: AspectRatio(
                  aspectRatio: 1,
                  // ignore: unnecessary_null_comparison
                  child: productList!.first != null
                      ? SingleProduct(
                          image: productList!.first.productImage[0],
                          price:
                              '฿ ${productList!.first.productPrice.toString()}/KG',
                          productName: productList!.first.productName,
                          ratings: avgRating,
                          productPriceList: productpricesList,
                          productList: productList![0],
                        )
                      : const Loader(),
                ),
              ),
            ],
          ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 0; i < (productList?.length ?? 0); i++)
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      ProductDetailScreen.routeName,
                      arguments: productList![i],
                    );
                  },
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: productList != null
                        ? SingleOrderProduct(
                            image: productList![i].productImage[0],
                            price: productList![i].productPrice.toString(),
                            salePrice: productList![i].productSalePrice,
                            productPriceList: productpricesList,
                            productName: productList![i].productName,
                            ratings: 0,
                            productList: productList![i],
                          )
                        : const Loader(),
                  ),
                ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
          ).copyWith(left: 15),
          alignment: Alignment.topLeft,
        ),
      ],
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
  final Product productList;
  const SingleOrderProduct({
    Key? key,
    required this.image,
    required this.price,
    this.salePrice,
    required this.productPriceList,
    required this.productName,
    required this.ratings,
    required this.productList,
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

    double totalRating = 0.0;
    double avgRating = 0.0;
    double rateAllProduct = 0.0;
    void ratings() {
      for (int j = 0; j < productList.rating!.length; j++) {
        totalRating += productList.rating![j].rating;
      }
      if (productList.rating!.isNotEmpty) {
        avgRating = totalRating / productList.rating!.length;
        rateAllProduct += avgRating;
      }
    }

    ratings();
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
                  'ราคาตลาดวันนี้ $mocPrice ฿',
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
              child: Stars(rating: avgRating),
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
      "$price฿",
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

class SingleProduct extends StatelessWidget {
  final String image;
  final String price;
  final String? salePrice;
  final String productName;
  final double ratings;
  final List<ProductPrice> productPriceList;
  final Product productList;
  const SingleProduct({
    Key? key,
    required this.image,
    required this.price,
    this.salePrice,
    required this.productPriceList,
    required this.productName,
    required this.ratings,
    required this.productList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String mocPrice = '';

    // ignore: no_leading_underscores_for_local_identifiers
    void _getSalePrice() {
      for (int i = 0; i < productPriceList.length; i++) {
        if (productPriceList[i].productId == productList.productSalePrice) {
          mocPrice = productPriceList[i].priceMax.toString();
        }
      }
    }

    double totalRating = 0.0;
    double avgRating = 0.0;

    double rateAllProduct = 0.0;
    void ratings() {
      for (int j = 0; j < productList.rating!.length; j++) {
        totalRating += productList.rating![j].rating;
      }
      if (productList.rating!.isNotEmpty) {
        avgRating = totalRating / productList.rating!.length;
        rateAllProduct += avgRating;
      }
    }

    ratings();
    _getSalePrice();

    return FittedBox(
      fit: BoxFit.fill,
      child: Container(
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'ราคาตลาดวันนี้ $mocPrice ฿',
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
                child: Stars(rating: avgRating),
              ),
            ),
          ],
        ),
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
      "$price฿",
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
