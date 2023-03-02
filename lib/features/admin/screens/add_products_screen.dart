import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:kmutnb_project/common/widgets/custom_textfield.dart';
import 'package:kmutnb_project/common/widgets/customer_button.dart';
import 'package:kmutnb_project/features/admin/services/admin_service.dart';
import 'package:http/http.dart' as http;
import '../../../constants/global_variables.dart';
import '../../../constants/utills.dart';
import '../../../models/category.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = '/add-product';
  const AddProductScreen({Key? key}) : super(key: key);

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
  final CategoryService categoryServices = CategoryService();
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

  @override
  void initState() {
    super.initState();
    _getCategories();
  }

  List<Category> categories = [];
  String selectedCategoryId = '';

  void _getCategories() async {
    categories = await categoryServices.fetchAllCategory(context);
    selectedCategoryId = categories.first.categoryId;

    setState(() {});
  }

  void sellProduct() {
    if (_addProductFormKey.currentState!.validate() && images.isNotEmpty) {
      adminServices.sellProduct(
        context: context,
        productName_: productNameController.text,
        productDescription_: descriptionController.text,
        category_: selectedCategoryId,
        productImage_: images,
        productPrice_: double.parse(priceController.text),
        productSKU_: quantityController.text,
        productSalePrice_: 0,
        productShortDescription_: 'test',
        productType_: 'test',
        relatedProduct_: 'test',
        stockStatus_: 'test',
      );
    } else {
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Please enter valid product data and at least one image.'),
        ),
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
                                      color: Colors.grey.shade400,
                                    ),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Product Name is required';
                      }
                      return null;
                    },
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
                    validator: (value) {
                      return null;
                    },
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
                    validator: (value) {
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      text: "จำนวนสินค้า",
                      style: TextStyle(
                        color: Colors.black.withOpacity(1.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  CustomTextField(
                    controller: quantityController,
                    hintText: 'quantitiy',
                    validator: (value) {
                      return null;
                    },
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: DropdownButton(
                      hint: Text('Select a category'),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: categories.map((categories) {
                        return DropdownMenuItem<String>(
                          value: categories.categoryId,
                          child: Text(categories.categoryName),
                        );
                      }).toList(),
                      onChanged: (String? newVal) {
                        setState(() {
                          selectedCategoryId = newVal!;
                        });
                      },
                    ),
                  ),
                  Text(() {
                    try {
                      final category = categories.firstWhere((category) =>
                          category.categoryId == selectedCategoryId);
                      return category.categoryName;
                    } catch (e) {
                      return 'No category selected';
                    }
                  }()),
                  const SizedBox(height: 10),
                  CustomButton(
                    text: 'Sell',
                    onTap: sellProduct,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
