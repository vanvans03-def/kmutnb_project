import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:kmutnb_project/constants/utills.dart';
import 'package:kmutnb_project/features/auth/widgets/constants.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/customer_button.dart';
import '../../../constants/global_variables.dart';
import '../../../models/order.dart';

import '../../../providers/user_provider.dart';
import '../../home/screens/store_product_screen.dart';
import '../../product_details/services/product_details_service.dart';
import '../../search/screens/search_screen.dart';

class OrderDetailScreen extends StatefulWidget {
  static const String routeName = '/order-details';
  final Order order;
  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  int currentStep = 0;
  int indexProduct = 0;
  bool showContainer = true;
  String storeId = '';
  String productId = '';
  String orderId = '';
  int checkOrder = 0;
  int index = 0;
  bool changeRating = false;
  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  @override
  void initState() {
    super.initState();

    if (widget.order.products[indexProduct].statusProductOrder > 3) {
      checkOrder = widget.order.products[indexProduct].statusProductOrder;
      if (checkOrder == 4) {
        currentStep = 3;
      } else if (checkOrder == 5) {
        currentStep = 4;
      } else {
        currentStep = 0;
      }
      showContainer = false;
    } else {
      currentStep = widget.order.products[indexProduct].statusProductOrder;
    }

    if (widget.order.products.length == 1) {
      showContainer = true;
    }
  }

  Future<void> returnOrderstatus(
      int status, String orderId, String productId, String storeId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('คืนสินค้า'),
          content: const Text('คุณยืนยันที่จะคืนสินค้านี้ใช่ไหม?'),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text(
                'ยืนยัน',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                adminService.changeOrderStatus(
                    context: context,
                    status: status + 1,
                    orderId: orderId,
                    storeId: storeId,
                    productId: productId,
                    onSuccess: () {});
                setState(() {
                  currentStep += 1;
                  checkOrder = currentStep;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  final ProductDetailsServices productDetailsServices =
      ProductDetailsServices();
  double myRating = 0;
  double avgRating = 0;
  String mocPrice = '';

  Future<void> reviewProduct(String productId) async {
    double totalRating = 0;
    for (int i = 0;
        i < widget.order.products[indexProduct].product.rating!.length;
        i++) {
      totalRating +=
          widget.order.products[indexProduct].product.rating![i].rating;
      if (widget.order.products[indexProduct].product.rating![i].userId ==
              Provider.of<UserProvider>(context, listen: false).user.id &&
          !changeRating) {
        myRating =
            widget.order.products[indexProduct].product.rating![i].rating;
      }
    }

    if (widget.order.products[indexProduct].product.rating!.isNotEmpty) {
      avgRating = totalRating /
          widget.order.products[indexProduct].product.rating!.length;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('รีวิวสินค้า'),
          content: Container(
            alignment: Alignment.centerLeft,
            height: 120, // ปรับความสูงตามต้องการ
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'ให้คะแนนสินค้าหลังจากได้รับสินค้าแล้ว',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8), // เพิ่ม SizedBox สำหรับระยะห่าง
                SizedBox(
                  height: 40,
                  child: RatingBar.builder(
                    initialRating: myRating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 1),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: GlobalVariables.secondaryColor,
                    ),
                    onRatingUpdate: (rating) {
                      productDetailsServices.rateProduct(
                        context: context,
                        productID: productId,
                        rating: rating,
                      );
                      showSnackBar(context, 'ให้คะแนนสินค้าเรียบร้อยแล้ว');
                      changeRating = true;
                      if (changeRating) {
                        myRating = rating;
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //final user = Provider.of<UserProvider>(context).user;

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
                        hintText: 'Search Product',
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'รายละเอียดออเดอร์',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('วันที่ของออเดอร์:      ${DateFormat().format(
                      DateTime.fromMillisecondsSinceEpoch(
                          widget.order.orderedAt),
                    )}'),
                    Text('รหัสออเดอร์:            ${widget.order.id}'),
                    Text('ยอดรวมออเดอร์:      \฿${widget.order.totalPrice}'),
                    Text('รูปแบบการจัดส่ง:     ${widget.order.deliveryType}')
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'รายละเอียดการซื้อ',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (int i = 0; i < widget.order.products.length; i++)
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (indexProduct == i && showContainer) {
                              if (widget.order.products.length != 1) {
                                showContainer = false;
                              }

                              checkOrder =
                                  widget.order.products[i].statusProductOrder;
                              if (widget.order.products[i].statusProductOrder >
                                  3) {
                                currentStep = 3;
                              } else {
                                currentStep =
                                    widget.order.products[i].statusProductOrder;
                              }
                            } else {
                              showContainer = true;
                              indexProduct = i;
                              checkOrder =
                                  widget.order.products[i].statusProductOrder;
                              if (widget.order.products[i].statusProductOrder >
                                  3) {
                                currentStep = 3;
                              } else {
                                currentStep =
                                    widget.order.products[i].statusProductOrder;
                              }
                            }
                          });
                        },
                        child: Row(
                          children: [
                            Image.network(
                              widget.order.products[i].product.productImage[0],
                              height: 120,
                              width: 120,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget
                                        .order.products[i].product.productName,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'จำนวน: ${widget.order.products[i].productSKU} ${widget.order.products[i].product.productType.substring(widget.order.products[i].product.productType.indexOf('/') + 1)}',
                                  ),
                                  Text(
                                    'ราคาต: ${widget.order.products[i].product.productPrice} ${widget.order.products[i].product.productType}',
                                  ),
                                  Radio(
                                    value:
                                        i, // ค่าที่แตกต่างกันสำหรับแต่ละรายการสินค้า
                                    groupValue:
                                        indexProduct, // ค่าปัจจุบันของรายการสินค้าที่ถูกเลือก
                                    onChanged: (value) {
                                      setState(() {
                                        indexProduct = value as int;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'ติดตามสินค้า',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
              if (showContainer && checkOrder < 4) ...[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black12,
                    ),
                  ),
                  child: Stepper(
                    currentStep: currentStep,
                    controlsBuilder: (context, details) {
                      if (currentStep >= 0 && currentStep <= 3) {
                        if (currentStep == 3) {
                          return Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 30,
                                      width: 110,
                                      child: CustomButton(
                                          color: GlobalVariables.secondaryColor,
                                          text: 'รีวิวสินค้า',
                                          onTap: () async {
                                            await reviewProduct(
                                              widget
                                                  .order
                                                  .products[indexProduct]
                                                  .product
                                                  .id
                                                  .toString(),
                                            );
                                            setState(() {});
                                          }),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      height: 30,
                                      width: 110,
                                      child: CustomButton(
                                          color: Colors.red.shade400,
                                          text: 'คืนสินค้า',
                                          onTap: () {
                                            returnOrderstatus(
                                                3,
                                                widget.order.id,
                                                widget
                                                    .order
                                                    .products[indexProduct]
                                                    .product
                                                    .id
                                                    .toString(),
                                                widget
                                                    .order
                                                    .products[indexProduct]
                                                    .product
                                                    .storeId);
                                            setState(() {});
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }

                        return const SizedBox();
                      } else
                        return Text("กำลังคืนสินค้า");
                    },
                    steps: [
                      Step(
                        title: const Text('รอดำเนินการ'),
                        content: const Text(
                          'คำสั่งซื้อของคุณยังไม่ได้รับการจัดส่ง',
                        ),
                        isActive: currentStep > 0,
                        state: currentStep > 0
                            ? StepState.complete
                            : StepState.indexed,
                      ),
                      Step(
                        title: const Text('ร้านค้าได้รับออเดอร์แล้ว'),
                        content: const Text(
                          'ผู้ขายกำลังแพ็คสินค้าเพื่อจัดส่งสินค้าให้คุณ',
                        ),
                        isActive: currentStep > 1,
                        state: currentStep > 1
                            ? StepState.complete
                            : StepState.indexed,
                      ),
                      Step(
                        title: const Text('กำลังจัดส่งสินค้า'),
                        content: const Text(
                          'ผู้ขายได้จัดส่งสินค้าของคุณให้ขนส่งแล้ว',
                        ),
                        isActive: currentStep > 2,
                        state: currentStep > 2
                            ? StepState.complete
                            : StepState.indexed,
                      ),
                      Step(
                        title: const Text('สินค้าส่งถึงแล้ว'),
                        content: const Text(
                          'คำสั่งซื้อของคุณได้ถูกจัดส่งและลงนามโดยคุณแล้ว',
                        ),
                        isActive: currentStep >= 3,
                        state: currentStep >= 3
                            ? StepState.complete
                            : StepState.indexed,
                      ),
                    ],
                  ),
                )
              ] else if (checkOrder == 4) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: GlobalVariables.kPrimaryColor,
                    ),
                  ),
                  child: const Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'คำขอคืนออเดอร์ถูกส่งแล้ว',
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                )
              ] else if (checkOrder == 5) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: GlobalVariables.kPrimaryColor,
                    ),
                  ),
                  child: const Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'การคืนออเดอร์สำเร็จแล้ว',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                )
              ] else
                const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
