import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kmutnb_project/features/admin/services/admin_service.dart';
import 'package:kmutnb_project/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../../../common/widgets/customer_button.dart';
import '../../../constants/global_variables.dart';
import '../../../models/orderStore.dart';
import '../../search/screens/search_screen.dart';

class OrderStoreDetailScreen extends StatefulWidget {
  static const String routeName = '/order-store-details';
  final OrderStore order;
  const OrderStoreDetailScreen({super.key, required this.order});

  @override
  State<OrderStoreDetailScreen> createState() => _OrderStoreDetailScreen();
}

class _OrderStoreDetailScreen extends State<OrderStoreDetailScreen> {
  int currentStep = 0;
  int indexProduct = 0;
  bool showContainer = true;
  String storeId = '';
  String productId = '';
  String orderId = '';
  AdminService adminService = AdminService();
  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  @override
  void initState() {
    super.initState();

    currentStep = widget.order.products[indexProduct].statusProductOrder;
    if (widget.order.products.length == 1) {
      showContainer = true;
      storeId = widget.order.products[indexProduct].storeId;
      productId = widget.order.products[indexProduct].id;
      orderId = widget.order.id;
    }
  }

  void changeOrderstatus(
      int status, String orderId, String productId, String storeId) {
    adminService.changeOrderStatus(
        context: context,
        status: status + 1,
        orderId: orderId,
        storeId: storeId,
        productId: productId,
        onSuccess: () {});
    setState(() {
      currentStep += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    //final user = Provider.of<UserProvider>(context).user;
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: const Text(
            'order Details',
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.w600),
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
                'View order details',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
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
                    Text('Order Date:      ${DateFormat().format(
                      DateTime.fromMillisecondsSinceEpoch(
                          widget.order.orderedAt),
                    )}'),
                    Text('Order ID:          ${widget.order.id}'),
                    Text('Order Total:      \฿${widget.order.totalPrice}'),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Purchase Details',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
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
                            /*  if (indexProduct == i && showContainer) {
                              if (widget.order.products.length != 1) {
                                showContainer = false;
                              }

                              currentStep =
                                  widget.order.products[i].statusProductOrder;
                            } else {
                              showContainer = true;
                              indexProduct = i;
                              currentStep =
                                  widget.order.products[i].statusProductOrder;
                            }
                          });*/
                            if (indexProduct == i && showContainer) {
                              if (widget.order.products.length != 1) {
                                showContainer = false;
                              }

                              storeId = widget.order.products[i].storeId;
                              productId = widget.order.products[i].id;
                              orderId = widget.order.id;
                              currentStep =
                                  widget.order.products[i].statusProductOrder;
                            } else {
                              showContainer = true;
                              indexProduct = i;
                              storeId = widget.order.products[i].storeId;
                              productId = widget.order.products[i].id;
                              orderId = widget.order.id;
                              currentStep =
                                  widget.order.products[i].statusProductOrder;
                            }
                          });
                        },
                        child: Row(
                          children: [
                            Image.network(
                              widget.order.products[i].productImage[0],
                              height: 120,
                              width: 120,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.order.products[i].productName,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Qty: ${widget.order.products[i].productQuantity}',
                                  ),
                                  Text(
                                    'Price: ${widget.order.products[i].productPrice}',
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
                'Tracking',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (showContainer)
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black12,
                    ),
                  ),
                  child: Stepper(
                    currentStep: currentStep,
                    controlsBuilder: (context, details) {
                      if (user.type == 'merchant' && currentStep != 3) {
                        return CustomButton(
                          text: 'Done',
                          onTap: () => changeOrderstatus(
                              details.currentStep, orderId, productId, storeId),
                        );
                      }
                      return const SizedBox();
                    },
                    steps: [
                      Step(
                        title: const Text('Pending'),
                        content: const Text(
                          'Your order is yet to be delivered',
                        ),
                        isActive: currentStep > 0,
                        state: currentStep > 0
                            ? StepState.complete
                            : StepState.indexed,
                      ),
                      Step(
                        title: const Text('Completed'),
                        content: const Text(
                          'Your order has been delivered, you are yet to sign.',
                        ),
                        isActive: currentStep > 1,
                        state: currentStep > 1
                            ? StepState.complete
                            : StepState.indexed,
                      ),
                      Step(
                        title: const Text('Received'),
                        content: const Text(
                          'Your order has been delivered and signed by you.',
                        ),
                        isActive: currentStep > 2,
                        state: currentStep > 2
                            ? StepState.complete
                            : StepState.indexed,
                      ),
                      Step(
                        title: const Text('Delivered'),
                        content: const Text(
                          'Your order has been delivered and signed by you!',
                        ),
                        isActive: currentStep >= 3,
                        state: currentStep >= 3
                            ? StepState.complete
                            : StepState.indexed,
                      ),
                    ],
                  ),
                )
              else
                const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
