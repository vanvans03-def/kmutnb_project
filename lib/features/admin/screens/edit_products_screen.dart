import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:kmutnb_project/common/widgets/custom_textfield.dart';
import 'package:kmutnb_project/common/widgets/customer_button.dart';
import 'package:kmutnb_project/features/admin/services/admin_service.dart';
import 'package:kmutnb_project/models/productprice.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utills.dart';
import '../../../models/category.dart';
import '../../../models/product.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = '/edit-product';
  final Product productData;

  const EditProductScreen({Key? key, required this.productData})
      : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController productTypeController = TextEditingController();
  final AdminService adminServices = AdminService();
  final CategoryService categoryServices = CategoryService();
  List<File> images = [];
  final _editProductFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
    productTypeController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getCategories();
    _getProductPrices();
    // Set the initial values for the text fields
    productNameController.text = widget.productData.productName;
    descriptionController.text = widget.productData.productDescription;
    priceController.text = widget.productData.productPrice.toString();
    quantityController.text = widget.productData.productSKU;
    productTypeController.text = widget.productData.productType;
  }

  List<Category> categories = [];
  String selectedCategoryId = '';

  String? selectedProductPriceId;
  List<ProductPrice> productPrices = [];
  List<ProductPrice> productPricesList = [];

  void _getProductPrices() async {
    productPricesList = await adminServices.fetchAllProductprice(context);

    setState(() {});
  }

  void _getCategories() async {
    categories = await categoryServices.fetchAllCategory(context);
    selectedCategoryId = categories.first.categoryId;

    setState(() {});
  }

  void updateProduct() {
    if (_editProductFormKey.currentState!.validate() && images.isEmpty) {
      adminServices.updateProduct(
        context: context,
        productName_: productNameController.text,
        productDescription_: descriptionController.text,
        category_: selectedCategoryId,
        productPrice_: double.parse(priceController.text),
        productSKU_: quantityController.text,
        productSalePrice_: selectedProductPriceId.toString(),
        productShortDescription_: 'test',
        productType_: 'test',
        relatedProduct_: 'test',
        stockStatus_: 'test',
        productID: widget.productData.id.toString(),
        productImage_: [],
        imageWidget: widget.productData.productImage,
      );

      setState(() {});
    } else if (_editProductFormKey.currentState!.validate() &&
        images.isNotEmpty) {
      adminServices.updateProduct(
        context: context,
        productName_: productNameController.text,
        productDescription_: descriptionController.text,
        category_: selectedCategoryId,
        productPrice_: double.parse(priceController.text),
        productSKU_: quantityController.text,
        productSalePrice_: selectedProductPriceId.toString(),
        productShortDescription_: 'test',
        productType_: 'test',
        relatedProduct_: 'test',
        stockStatus_: 'test',
        productID: widget.productData.id.toString(),
        productImage_: images,
        imageWidget: widget.productData.productImage,
      );
    } else {
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid product data.'),
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
            'Edit Product',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _editProductFormKey,
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
                        child: CarouselSlider(
                          items: widget.productData.productImage.map(
                            (i) {
                              return Image.network(
                                widget.productData.productImage[0],
                                fit: BoxFit.cover,
                                height: 200,
                              );
                            },
                          ).toList(),
                          options: CarouselOptions(
                            viewportFraction: 1,
                            height: 200,
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
                ElevatedButton(
                  onPressed: () async {
                    String productName = productNameController.text;
                    List<ProductPrice> searchedProductPrices =
                        await adminServices.searchProductprice(
                      context: context,
                      productName: productName,
                    );

                    setState(() {
                      productPrices = searchedProductPrices;
                      selectedProductPriceId = productPrices
                          .first.productId; // Set a default value here
                    });
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "ราคาสินค้าวันนี้",
                      style: TextStyle(
                        color: Colors.white.withOpacity(1.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (productPrices.isNotEmpty)
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedProductPriceId,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedProductPriceId = newValue!;
                          });
                        },
                        items: [
                          const DropdownMenuItem<String>(
                            value: '0',
                            child: Text(
                                'ไม่มีสินค้าที่ใกล้เคียง/ไม่แสดงราคาสินค้าแนะนำ'),
                          ),
                          ...productPrices.map((productPrice) {
                            return DropdownMenuItem<String>(
                              value: productPrice.productId,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        productPrice.productName,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text('Price: ${productPrice.priceMax}'),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
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
                  hintText: 'Quantity',
                  validator: (value) {
                    return null;
                  },
                ),
                RichText(
                  text: TextSpan(
                    text: "ประเภทสินค้า",
                    style: TextStyle(
                      color: Colors.black.withOpacity(1.0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedCategoryId,
                      onChanged: (String? newVal) {
                        setState(() {
                          selectedCategoryId = newVal!;
                        });
                      },
                      items: categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category.categoryId,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(category.categoryName),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: 'Update',
                  onTap: updateProduct,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
