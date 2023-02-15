import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:kmutnb_project/common/widgets/custom_textfield.dart';
import 'package:kmutnb_project/common/widgets/customer_button.dart';
import 'package:kmutnb_project/constants/utills.dart';
import 'package:kmutnb_project/features/admin/services/admin_service.dart';

import '../../../constants/global_variables.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = '/add-product';
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController productTypeController = TextEditingController();
  final AdminService adminServices = AdminService();
  String category = 'fruit';
  List<File> images = [];
  final _addProductFormKey = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
    productTypeController.dispose();
  } //สร้างตัวแปรตาม json

  List<String> productCategories = [
    'fruit',
    'vegetable',
    'dry fruit',
  ];
  void sellProduct() {
    if (_addProductFormKey.currentState!.validate() && images.isEmpty) {
      adminServices.sellProduct(
        context: context,
        productName: productNameController.text,
        productDescription: descriptionController.text,
        category: 'test',
        productImage: images,
        productPrice: double.parse(priceController.text),
        productSKU: quantityController.text,
        productSalePrice: 0,
        productShortDescription: 'test',
        productType: category,
        relatedProduct: 'test',
        stockStatus: 'test',
      );
    }
  }

  void selectImages() async {
    var res = await pickImage();
    setState(() {
      images = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: const Text(
            'Add Product',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _addProductFormKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  images.isNotEmpty
                      ? CarouselSlider(
                          items: images.map(
                            (i) {
                              return Builder(
                                builder: (BuildContext context) => Image.file(
                                  i,
                                  fit: BoxFit.cover,
                                  height: 200,
                                ),
                              );
                            },
                          ).toList(),
                          options: CarouselOptions(
                            viewportFraction: 1,
                            height: 200,
                          ),
                        )
                      : GestureDetector(
                          onTap: selectImages,
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(10),
                            dashPattern: const [10, 4],
                            strokeCap: StrokeCap.round,
                            child: Container(
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.folder_open,
                                    size: 40,
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    'Select Product Images',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey.shade400),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 30),
                  RichText(
                    text: TextSpan(
                      text: "ชื่อสินค้า",
                      style: TextStyle(
                        color: Colors.black.withOpacity(1.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  CustomTextField(
                    controller: productNameController,
                    hintText: 'Product Name',
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      text: "รายละเอียดสินค้า",
                      style: TextStyle(
                        color: Colors.black.withOpacity(1.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  CustomTextField(
                    controller: descriptionController,
                    hintText: 'Description',
                    maxLines: 7,
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      text: "ราคาสินค้า",
                      style: TextStyle(
                        color: Colors.black.withOpacity(1.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  CustomTextField(
                    controller: priceController,
                    hintText: 'Price',
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      text: "ชื่อสินค้า",
                      style: TextStyle(
                        color: Colors.black.withOpacity(1.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  CustomTextField(
                    controller: quantityController,
                    hintText: 'จำนวนสินค้า',
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: DropdownButton(
                      value: category,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: productCategories.map((String item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (String? newVal) {
                        setState(() {
                          category = newVal!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomButton(
                    text: 'Sell',
                    onTap: sellProduct,
                  )
                ],
              ),
            )),
      ),
    );
  }
}
