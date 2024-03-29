import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:kmutnb_project/features/account/services/account_service.dart';
import 'package:kmutnb_project/features/account/widgets/single_order_product.dart';
import 'package:kmutnb_project/features/auth/widgets/constants.dart';
import 'package:kmutnb_project/features/order_detail/screens/order_details.dart';
import 'package:kmutnb_project/models/order.dart';
import 'package:kmutnb_project/common/widgets/loader.dart';

class OrdersSucees extends StatefulWidget {
  static const routeName = '/orders_sucees';
  const OrdersSucees({Key? key}) : super(key: key);

  @override
  State<OrdersSucees> createState() => _OrdersSucees();
}

class _OrdersSucees extends State<OrdersSucees> {
  List<Order>? orders;
  List<Order>? orderList;
  final AccountServices accountServices = AccountServices();

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    orderList = await accountServices.fetchMyOrder(context);
    orders = []; // Add this line to initialize the orders list
    for (int i = 0; i < orderList!.length; i++) {
      bool isAllProductsStatus3 = true;
      for (int j = 0; j < orderList![i].products.length; j++) {
        if (orderList![i].products[j].statusProductOrder != 3) {
          isAllProductsStatus3 = false;
          break;
        }
      }
      if (isAllProductsStatus3) {
        orders!.add(orderList![i]);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders Success'),
      ),
      body: orders == null
          ? const Loader()
          : Container(
              margin: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      'ออเดอร์ที่ได้รับแล้ว',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: OrientationBuilder(
                      builder: (context, orientation) {
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                orientation == Orientation.portrait ? 2 : 4,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio:
                                orientation == Orientation.portrait
                                    ? 0.82
                                    : 0.56,
                          ),
                          itemCount: orders!.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  OrderDetailScreen.routeName,
                                  arguments: orders![index],
                                );
                              },
                              child: SingleOrderProduct(
                                image: orders![index]
                                    .products[0]
                                    .product
                                    .productImage[0],
                                date: DateFormat().format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                    orders![index].orderedAt,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
