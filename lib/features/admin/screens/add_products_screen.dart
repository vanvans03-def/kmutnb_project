import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:kmutnb_project/common/widgets/custom_textfield.dart';

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

  @override
  void dispose() {
    super.dispose();
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
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
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              DottedBorder(
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
                            fontSize: 15, color: Colors.grey.shade400),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              CustomTextField(
                controller: productNameController,
                hintText: 'Product Name',
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: descriptionController,
                hintText: 'Description',
              ),
              const SizedBox(height: 10), //5.00
            ],
          ),
        )),
      ),
    );
  }
}
