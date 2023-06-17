// ignore_for_file: body_might_complete_normally_nullable, prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kmutnb_project/constants/utills.dart';
import 'package:kmutnb_project/features/auth/widgets/constants.dart';
import 'package:kmutnb_project/providers/user_provider.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/custom_textfield.dart';
import '../../../constants/global_variables.dart';
import '../services/address_services.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = '/address';
  final String totalAmount;
  const AddressScreen({Key? key, required this.totalAmount}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController flatBuildingController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final _addressFormKey = GlobalKey<FormState>();
  String addressToBeUsed = "";
  File? _selectedImage;
  List<PaymentItem> _paymentItems = [];
  String? image64;
  final AddressService addressService = AddressService();
  String? slipImage;
  bool tap = false;
  @override
  void initState() {
    super.initState();
    _paymentItems.add(PaymentItem(
      amount: widget.totalAmount,
      label: 'Total Amount',
      status: PaymentItemStatus.final_price,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    flatBuildingController.dispose();
    areaController.dispose();
    pincodeController.dispose();
    cityController.dispose();
  }

  Future<void> showSlip() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          'สลิปการโอนเงินของคุณ',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: kPrimaryColor,
          ),
        ),
        content: Container(
          height: 500.0,
          decoration: const BoxDecoration(
            color: Colors.orange,
          ),
          child: Image.file(
            _selectedImage!,
            fit: BoxFit.cover,
          ),
        ),
        actions: [
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'ออก',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> getQrCode() async {
    image64 = await addressService.getQrCode(
        context: context, totalSum: double.parse(widget.totalAmount));
    final base64Image = image64!.substring(image64!.indexOf(',') + 1);
    if (base64Image.isNotEmpty) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            'QR Code ทั้งหมด ${widget.totalAmount} ฿',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
          content: Image.memory(
            base64Decode(base64Image),
            width: 200,
            height: 200,
          ),
          actions: [
            Column(
              children: [
                if (tap) ...[
                  Container(
                    height: 150.0,
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                    ),
                    child: Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                    ),
                  )
                ],
                Row(
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                      ),
                      onPressed: () async {
                        if (_selectedImage != null) {
                          showSlip();
                        } else {
                          showSnackBar(context, 'กรุณาอัปโหลดสลิป');
                        }

                        setState(() {});
                      },
                      icon: Icon(Icons.open_in_new), // ไอคอนที่แสดงในปุ่ม
                      label: Text(
                        'แสดงรูปภาพ',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ), // ข้อความที่แสดงในปุ่ม
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        File? image = await pickOneImage();

                        setState(() {
                          _selectedImage = image;
                        });
                      },
                      icon: Icon(Icons.add), // ไอคอนที่แสดงในปุ่ม
                      label: Text(
                        'เพิ่มรูปภาพ',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ), // ข้อความที่แสดงในปุ่ม
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            if (_selectedImage != null) {
                              onPromptPayResult();
                            } else {
                              showSnackBar(context, "กรุณาอัปโหลดสลิป");
                            }
                          },
                          child: const Text('ยืนยัน'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'ออก',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  void onGooglePayResult(paymentResult) {
    if (Provider.of<UserProvider>(context, listen: false)
        .user
        .address
        .isEmpty) {
      addressService.saveUser(context: context, address: addressToBeUsed);
    }
    addressService.placeOrder(
        context: context,
        address: addressToBeUsed,
        totalSum: double.parse(widget.totalAmount),
        image: _selectedImage);
  }

  Future<File?> pickOneImage() async {
    File? image;
    try {
      var files = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (files != null && files.files.isNotEmpty) {
        image = File(files.files.first.path!);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    setState(() {});
    return image;
  }

  Future<void> onPromptPayResult() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var address = userProvider.user.address;
    payPressed(address);

    if (Provider.of<UserProvider>(context, listen: false)
        .user
        .address
        .isEmpty) {
      addressService.saveUser(context: context, address: addressToBeUsed);
    }

    addressService.placeOrder(
      context: context,
      address: addressToBeUsed,
      totalSum: double.parse(widget.totalAmount),
      image: _selectedImage,
    );
  }

  void onApplePayResult(paymentResult) {
    // Send the resulting Apple Pay token to your server / PSP
  }

  void payPressed(String addressFromProvider) {
    addressToBeUsed = "";

    bool isForm = flatBuildingController.text.isNotEmpty ||
        areaController.text.isNotEmpty ||
        pincodeController.text.isNotEmpty ||
        cityController.text.isNotEmpty;
    if (isForm) {
      if (_addressFormKey.currentState!.validate()) {
        addressToBeUsed =
            '${flatBuildingController.text},${areaController.text},${cityController.text} - ${pincodeController.text}';
      } else {
        throw Exception('Please enter all the values!');
      }
    } else if (addressFromProvider.isNotEmpty) {
      addressToBeUsed = addressFromProvider;
    } else {
      showSnackBar(context, 'error');
    }
  }

  @override
  Widget build(BuildContext context) {
    var address = context.watch<UserProvider>().user.address;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Text(
            'เพิ่มที่อยู่และชำระสินค้า',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (address.isNotEmpty)
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          address,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'หรืออัปเดตที่อยู่ใหม่',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              Form(
                key: _addressFormKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: flatBuildingController,
                      hintText: 'Flat, House no, Building',
                      validator: (value) {},
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      controller: areaController,
                      hintText: 'Area, Street',
                      validator: (value) {},
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      controller: pincodeController,
                      hintText: 'Pincode',
                      validator: (value) {},
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      controller: cityController,
                      hintText: 'Town/City',
                      validator: (value) {},
                    ),
                  ],
                ),
              ),
              GooglePayButton(
                onPressed: () => payPressed(address),
                width: double.infinity,
                paymentConfigurationAsset: 'gpay.json',
                paymentItems: _paymentItems,
                type: GooglePayButtonType.pay,
                margin: const EdgeInsets.only(top: 15.0),
                onPaymentResult: onGooglePayResult,
                loadingIndicator: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              const SizedBox(height: 10),
              ApplePayButton(
                onPressed: () => payPressed(address),
                width: double.infinity,
                paymentConfigurationAsset: 'applepay.json',
                paymentItems: _paymentItems,
                style: ApplePayButtonStyle.black,
                type: ApplePayButtonType.buy,
                margin: const EdgeInsets.only(top: 15.0),
                onPaymentResult: onApplePayResult,
                loadingIndicator: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'หรือ',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        side: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  onPressed: () {
                    getQrCode();
                  },
                  child: Text(
                    "PromptPay QrCode".toUpperCase(),
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
