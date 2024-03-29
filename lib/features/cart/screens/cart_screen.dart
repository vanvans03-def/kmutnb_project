import 'package:flutter/material.dart';
import 'package:kmutnb_project/common/widgets/customer_button.dart';
import 'package:kmutnb_project/constants/utills.dart';
import 'package:kmutnb_project/features/address/screens/addres_screen.dart';
import 'package:kmutnb_project/features/auth/widgets/constants.dart';
import 'package:kmutnb_project/features/cart/widgets/cart_subtotal.dart';
import 'package:kmutnb_project/features/home/widgets/address_box.dart';
import 'package:kmutnb_project/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../../constants/global_variables.dart';
import '../../search/screens/search_screen.dart';
import '../widgets/cart_product.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  void navigateToAddress(double sum) {
    if (_selectedValue == null) {
      showSnackBar(context, 'กรุณาเลือกตัวเลือกการจัดส่ง');
    } else {
      Navigator.pushNamed(
        context,
        AddressScreen.routeName,
        arguments: {
          'totalAmount': sum.toString(),
          'deliveryType': _selectedValue,
        },
      );
    }
  }

  void showEmptyCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("แจ้งเตือน"),
          content: Text("กรุณาเพิ่มสินค้าในตระกร้า"),
          actions: <Widget>[
            TextButton(
              child: Text("ตกลง"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String? _selectedValue;

  List<bool> _isSelected = [true, false];
  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    double sum = 0;
    if (user.cart.isNotEmpty) {
      // เพิ่มเงื่อนไขการตรวจสอบว่าตะกร้ามีสินค้าหรือไม่
      user.cart
          .map((e) => sum += e['quantity'] *
              double.parse(e['product']['productPrice'].toString()))
          .toList();
    }

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
          children: <Widget>[
            const AddressBox(),
            const SizedBox(height: 10),
            if (user.cart.isNotEmpty) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          value: 'ส่งธรรมดา',
                          groupValue: _selectedValue,
                          onChanged: (value) {
                            setState(() {
                              _selectedValue = value;
                            });
                          },
                          title: const Text('ส่งธรรมดา'),
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          value: 'ส่งด่วนพิเศษ',
                          groupValue: _selectedValue,
                          onChanged: (value) {
                            setState(() {
                              _selectedValue = value;
                            });
                          },
                          title: const Text('ส่งด่วนพิเศษ'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (_selectedValue != null) ...[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text(
                            'ตัวเลือกการจัดส่ง: ',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '$_selectedValue',
                            style: const TextStyle(
                              fontSize: 16,
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]
                ],
              ),
            ],
            const SizedBox(height: 10),
            const CartSubtotal(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: user.cart.length == 0
                  ? CustomButton(
                      text:
                          'ดำเนินการต่อโดยสินค้า (${user.cart.length}) รายการ',
                      onTap: () => showEmptyCartDialog(
                          context), // ไม่มีการกำหนด onTap เพื่อให้ปุ่มไม่สามารถกดได้
                      color: Colors.grey, // สีปุ่มที่ไม่สามารถกดได้
                    )
                  : CustomButton(
                      text:
                          'ดำเนินการต่อโดยสินค้า (${user.cart.length}) รายการ',
                      onTap: () => navigateToAddress(sum),
                      color: Colors.yellow[600],
                    ),
            ),
            const SizedBox(height: 15),
            Container(
              color: Colors.black12.withOpacity(0.08),
              height: 1,
            ),
            const SizedBox(
              height: 5,
            ),

            // กำหนดความสูงสูงสุดของ ListView

            user.cart.isNotEmpty
                ? ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: user.cart.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return CartProduct(
                        index: index,
                      );
                    },
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
