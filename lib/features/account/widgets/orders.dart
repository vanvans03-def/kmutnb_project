// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kmutnb_project/constants/global_variables.dart';
import 'package:kmutnb_project/features/account/services/account_service.dart';
import 'package:kmutnb_project/features/account/widgets/single_order_product.dart';
import 'package:kmutnb_project/features/order_detail/screens/order_details.dart';
import 'package:kmutnb_project/models/order.dart';
import 'package:kmutnb_project/common/widgets/loader.dart';

import '../../admin/services/admin_service.dart';
import '../../auth/widgets/constants.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<Order>? orders;
  final AccountServices accountServices = AccountServices();

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    orders = await accountServices.fetchMyOrder(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return orders == null
        ? const Loader()
        : Scaffold(
            appBar: AppBar(
              toolbarHeight: 0,
              elevation: 2,
              backgroundColor: Colors.transparent,
            ),
            body: DefaultTabController(
              length: 3, // จำนวนแท็บทั้งหมด
              child: Column(
                children: [
                  SizedBox(
                    height: 35,
                    child: TabBar(
                      isScrollable: true,
                      tabs: [
                        Tab(
                          child: Text(
                            'ออเดอร์ทั้งหมด',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'สถานะออเดอร์',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'คืนสินค้าและคืนเงิน',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                      indicatorColor: kPrimaryColor,
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        AllOrderWidget(),
                        OrderderStatus(),
                        ReturnAndRefund(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

class OrderderStatus extends StatefulWidget {
  const OrderderStatus({super.key});

  @override
  State<OrderderStatus> createState() => _OrderderStatusState();
}

class _OrderderStatusState extends State<OrderderStatus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 4, // จำนวนแท็บทั้งหมด
        child: Column(
          children: [
            SizedBox(
              height: 35,
              child: TabBar(
                isScrollable: true,
                tabs: [
                  Tab(
                    child: Text(
                      'รอดำเนินการ',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'กำลังแพ็คสินค้า',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'กำลังจัดส่งสินค้า',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'ส่งสำเร็จ',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
                indicatorColor: kPrimaryColor,
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  OnHoldWidget(),
                  ProcessingWidget(),
                  DeliveredWidget(),
                  SucceedWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReturnAndRefund extends StatefulWidget {
  const ReturnAndRefund({super.key});

  @override
  State<ReturnAndRefund> createState() => _ReturnAndRefundState();
}

class _ReturnAndRefundState extends State<ReturnAndRefund> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2, // จำนวนแท็บทั้งหมด
        child: Column(
          children: [
            SizedBox(
              height: 35,
              child: TabBar(
                isScrollable: true,
                tabs: [
                  Tab(
                    child: Text(
                      'คำขอคืนเงินสินค้า',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'คืนเงินสินค้าเรียบร้อยแล้ว',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
                indicatorColor: kPrimaryColor,
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ReturnWidget(),
                  RefundWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AllOrderWidget extends StatefulWidget {
  @override
  _AllOrderWidgetState createState() => _AllOrderWidgetState();
}

class _AllOrderWidgetState extends State<AllOrderWidget> {
  final AccountServices accountServices = AccountServices();
  List<Order>? orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    orders = [];
    orders = await accountServices.fetchMyOrder(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Column(
            children: [
              Expanded(
                child: orders == null
                    ? const Loader()
                    : GridView.builder(
                        itemCount: orders!.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              orientation == Orientation.portrait ? 2 : 4,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio:
                              orientation == Orientation.portrait ? 0.8 : 0.7,
                        ),
                        padding: const EdgeInsets.all(10),
                        itemBuilder: (context, index) {
                          final orderData = orders![index];
                          final orderDate = DateFormat().format(
                            DateTime.fromMillisecondsSinceEpoch(
                                orderData.orderedAt),
                          );
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                OrderDetailScreen.routeName,
                                arguments: orderData,
                              ).then((value) {
                                fetchOrders();
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              // ...

                              child: Column(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: SingleOrderProduct(
                                        image: orderData.products[0].product
                                            .productImage[0],
                                        date: orderDate,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // ...
                            ),
                          );
                        },
                      ),
              )
            ],
          );
        },
      ),
    );
  }
}

class OnHoldWidget extends StatefulWidget {
  const OnHoldWidget({super.key});

  @override
  _OnHoldWidgetState createState() => _OnHoldWidgetState();
}

class _OnHoldWidgetState extends State<OnHoldWidget> {
  List<Order>? orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  final AccountServices accountServices = AccountServices();
  Future<void> fetchOrders() async {
    orders = [];
    List<Order>? orderList;
    orderList = await accountServices.fetchMyOrder(context);
    for (int i = 0; i < orderList.length; i++) {
      for (int j = 0; j < orderList[i].products.length; j++) {
        if (orderList[i].products[j].statusProductOrder == 0) {
          orders!.add(orderList[i]);
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Column(
            children: [
              Expanded(
                child: orders == null
                    ? const Loader()
                    : GridView.builder(
                        itemCount: orders!.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              orientation == Orientation.portrait ? 2 : 4,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio:
                              orientation == Orientation.portrait ? 0.8 : 0.7,
                        ),
                        padding: const EdgeInsets.all(10),
                        itemBuilder: (context, index) {
                          final orderData = orders![index];
                          final orderDate = DateFormat().format(
                            DateTime.fromMillisecondsSinceEpoch(
                                orderData.orderedAt),
                          );
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                OrderDetailScreen.routeName,
                                arguments: orderData,
                              ).then((value) {
                                fetchOrders();
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              // ...

                              child: Column(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: SingleOrderProduct(
                                        image: orderData.products[0].product
                                            .productImage[0],
                                        date: orderDate,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // ...
                            ),
                          );
                        },
                      ),
              )
            ],
          );
        },
      ),
    );
  }
}

class ProcessingWidget extends StatefulWidget {
  const ProcessingWidget({super.key});

  @override
  _ProcessingWidgetState createState() => _ProcessingWidgetState();
}

class _ProcessingWidgetState extends State<ProcessingWidget> {
  List<Order>? orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  final AccountServices accountServices = AccountServices();
  Future<void> fetchOrders() async {
    orders = [];
    List<Order>? orderList;
    orderList = await accountServices.fetchMyOrder(context);
    for (int i = 0; i < orderList.length; i++) {
      for (int j = 0; j < orderList[i].products.length; j++) {
        if (orderList[i].products[j].statusProductOrder == 1) {
          orders!.add(orderList[i]);
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Column(
            children: [
              Expanded(
                child: orders == null
                    ? const Loader()
                    : GridView.builder(
                        itemCount: orders!.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              orientation == Orientation.portrait ? 2 : 4,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio:
                              orientation == Orientation.portrait ? 0.8 : 0.7,
                        ),
                        padding: const EdgeInsets.all(10),
                        itemBuilder: (context, index) {
                          final orderData = orders![index];
                          final orderDate = DateFormat().format(
                            DateTime.fromMillisecondsSinceEpoch(
                                orderData.orderedAt),
                          );
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                OrderDetailScreen.routeName,
                                arguments: orderData,
                              ).then((value) {
                                fetchOrders();
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              // ...

                              child: Column(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: SingleOrderProduct(
                                        image: orderData.products[0].product
                                            .productImage[0],
                                        date: orderDate,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // ...
                            ),
                          );
                        },
                      ),
              )
            ],
          );
        },
      ),
    );
  }
}

class DeliveredWidget extends StatefulWidget {
  const DeliveredWidget({super.key});

  @override
  _DeliveredWidgetState createState() => _DeliveredWidgetState();
}

class _DeliveredWidgetState extends State<DeliveredWidget> {
  List<Order>? orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  final AccountServices accountServices = AccountServices();
  Future<void> fetchOrders() async {
    orders = [];
    List<Order>? orderList;
    orderList = await accountServices.fetchMyOrder(context);
    for (int i = 0; i < orderList.length; i++) {
      for (int j = 0; j < orderList[i].products.length; j++) {
        if (orderList[i].products[j].statusProductOrder == 2) {
          orders!.add(orderList[i]);
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Column(
            children: [
              Expanded(
                child: orders == null
                    ? const Loader()
                    : GridView.builder(
                        itemCount: orders!.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              orientation == Orientation.portrait ? 2 : 4,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio:
                              orientation == Orientation.portrait ? 0.8 : 0.7,
                        ),
                        padding: const EdgeInsets.all(10),
                        itemBuilder: (context, index) {
                          final orderData = orders![index];
                          final orderDate = DateFormat().format(
                            DateTime.fromMillisecondsSinceEpoch(
                                orderData.orderedAt),
                          );
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                OrderDetailScreen.routeName,
                                arguments: orderData,
                              ).then((value) {
                                fetchOrders();
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              // ...

                              child: Column(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: SingleOrderProduct(
                                        image: orderData.products[0].product
                                            .productImage[0],
                                        date: orderDate,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // ...
                            ),
                          );
                        },
                      ),
              )
            ],
          );
        },
      ),
    );
  }
}

class SucceedWidget extends StatefulWidget {
  const SucceedWidget({super.key});

  @override
  _SucceedWidgetState createState() => _SucceedWidgetState();
}

class _SucceedWidgetState extends State<SucceedWidget> {
  List<Order>? orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  final AccountServices accountServices = AccountServices();
  Future<void> fetchOrders() async {
    orders = [];
    List<Order>? orderList;
    orderList = await accountServices.fetchMyOrder(context);
    for (int i = 0; i < orderList.length; i++) {
      for (int j = 0; j < orderList[i].products.length; j++) {
        if (orderList[i].products[j].statusProductOrder == 3) {
          orders!.add(orderList[i]);
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Column(
            children: [
              Expanded(
                child: orders == null
                    ? const Loader()
                    : GridView.builder(
                        itemCount: orders!.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              orientation == Orientation.portrait ? 2 : 4,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio:
                              orientation == Orientation.portrait ? 0.8 : 0.7,
                        ),
                        padding: const EdgeInsets.all(10),
                        itemBuilder: (context, index) {
                          final orderData = orders![index];
                          final orderDate = DateFormat().format(
                            DateTime.fromMillisecondsSinceEpoch(
                                orderData.orderedAt),
                          );
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                OrderDetailScreen.routeName,
                                arguments: orderData,
                              ).then((value) {
                                fetchOrders();
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              // ...

                              child: Column(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: SingleOrderProduct(
                                        image: orderData.products[0].product
                                            .productImage[0],
                                        date: orderDate,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // ...
                            ),
                          );
                        },
                      ),
              )
            ],
          );
        },
      ),
    );
  }
}

class ReturnWidget extends StatefulWidget {
  const ReturnWidget({super.key});

  @override
  _ReturnWidgetState createState() => _ReturnWidgetState();
}

class _ReturnWidgetState extends State<ReturnWidget> {
  List<Order>? orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  final AccountServices accountServices = AccountServices();
  Future<void> fetchOrders() async {
    orders = [];
    List<Order>? orderList;
    orderList = await accountServices.fetchMyOrder(context);
    for (int i = 0; i < orderList.length; i++) {
      for (int j = 0; j < orderList[i].products.length; j++) {
        if (orderList[i].products[j].statusProductOrder == 4) {
          orders!.add(orderList[i]);
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Column(
            children: [
              Expanded(
                child: orders == null
                    ? const Loader()
                    : GridView.builder(
                        itemCount: orders!.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              orientation == Orientation.portrait ? 2 : 4,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio:
                              orientation == Orientation.portrait ? 0.8 : 0.7,
                        ),
                        padding: const EdgeInsets.all(10),
                        itemBuilder: (context, index) {
                          final orderData = orders![index];
                          final orderDate = DateFormat().format(
                            DateTime.fromMillisecondsSinceEpoch(
                                orderData.orderedAt),
                          );
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                OrderDetailScreen.routeName,
                                arguments: orderData,
                              ).then((value) {
                                fetchOrders();
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              // ...

                              child: Column(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: SingleOrderProduct(
                                        image: orderData.products[0].product
                                            .productImage[0],
                                        date: orderDate,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // ...
                            ),
                          );
                        },
                      ),
              )
            ],
          );
        },
      ),
    );
  }
}

class RefundWidget extends StatefulWidget {
  const RefundWidget({super.key});

  @override
  _RefundWidgetState createState() => _RefundWidgetState();
}

class _RefundWidgetState extends State<RefundWidget> {
  List<Order>? orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  final AccountServices accountServices = AccountServices();
  Future<void> fetchOrders() async {
    orders = [];
    List<Order>? orderList;
    orderList = await accountServices.fetchMyOrder(context);
    for (int i = 0; i < orderList.length; i++) {
      for (int j = 0; j < orderList[i].products.length; j++) {
        if (orderList[i].products[j].statusProductOrder == 5) {
          orders!.add(orderList[i]);
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Column(
            children: [
              Expanded(
                child: orders == null
                    ? const Loader()
                    : GridView.builder(
                        itemCount: orders!.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              orientation == Orientation.portrait ? 2 : 4,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio:
                              orientation == Orientation.portrait ? 0.8 : 0.7,
                        ),
                        padding: const EdgeInsets.all(10),
                        itemBuilder: (context, index) {
                          final orderData = orders![index];
                          final orderDate = DateFormat().format(
                            DateTime.fromMillisecondsSinceEpoch(
                                orderData.orderedAt),
                          );
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                OrderDetailScreen.routeName,
                                arguments: orderData,
                              ).then((value) {
                                fetchOrders();
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              // ...

                              child: Column(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: SingleOrderProduct(
                                        image: orderData.products[0].product
                                            .productImage[0],
                                        date: orderDate,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // ...
                            ),
                          );
                        },
                      ),
              )
            ],
          );
        },
      ),
    );
  }
}
