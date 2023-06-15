// ignore_for_file: unused_field

import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:kmutnb_project/common/widgets/custom_textfield.dart';
import 'package:kmutnb_project/common/widgets/customer_button.dart';

import 'package:kmutnb_project/models/province.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utills.dart';

import 'package:image_picker/image_picker.dart';

import '../services/add_store_service.dart';

class AddStoreScreen extends StatefulWidget {
  static const String routeName = '/add-store';
  const AddStoreScreen({Key? key}) : super(key: key);

  @override
  State<AddStoreScreen> createState() => _AddStoreScreenState();
}

class _AddStoreScreenState extends State<AddStoreScreen> {
  final TextEditingController storeNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController idcardController = TextEditingController();
  TextEditingController _coverImageController = TextEditingController();
  TextEditingController _storeImageController = TextEditingController();

  final AddStoreService addStoreService = AddStoreService();
  final ProvinceService provinceService = ProvinceService();
  File? images;
  final _addProductFormKey = GlobalKey<FormState>();
  File? _profileImage;
  File? _coverImage;
  @override
  void dispose() {
    super.dispose();
    storeNameController.dispose();
    descriptionController.dispose();
    phoneController.dispose();
  } //สร้างตัวแปรตาม json

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('คุณยังไม่มีร้านค้าในระบบ'),
            content: Text('กรุณาสร้างร้านค้าเพื่อใช้งานต่อไป'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('ตกลง'),
              ),
            ],
          );
        },
      );
    });
    _getProvinces();
  }

  List<Province> provinces = [];
  String selectedProvinceId = '';

  void _getProvinces() async {
    provinces = await provinceService.fetchAllProvince(context);
    selectedProvinceId = provinces.first.id;

    setState(() {});
  }

  void sellProduct() {
    if (_addProductFormKey.currentState!.validate()) {
      //image is not emopty
      addStoreService.createStore(
        context: context,
        storetName_: storeNameController.text,
        storetDescription_: descriptionController.text,
        storeImage_: images!,
        banner_: images!,
        phone_: phoneController.text,
        storeShortDescription_: '',
        storeStatus_: '',
        user_: '',
        province_: selectedProvinceId,
        idcardNo_: idcardController.text,
      );

      setState(() {});
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
    var res = await pickOneImage();
    setState(() {
      images = res;
    });
  }

  Future<void> _pickProfileImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _pickCoverImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (pickedImage != null) {
      setState(() {
        _coverImage = File(pickedImage.path);
      });
    }
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
            'สร้างร้านค้า',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
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
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      text: "ชื่อร้านค้า",
                      style: TextStyle(
                        color: Colors.black.withOpacity(1.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  CustomTextField(
                    controller: storeNameController,
                    hintText: 'Store Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Store Name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      text: "คำอธิบายร้านค้า",
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
                      text: "เบอร์โทรศัพท์ร้านค้า",
                      style: TextStyle(
                        color: Colors.black.withOpacity(1.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  CustomTextField(
                    controller: phoneController,
                    hintText: 'Phone number',
                    validator: (value) {
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      text: "รหัสบัตรประชาชน 13 หลัก",
                      style: TextStyle(
                        color: Colors.black.withOpacity(1.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  CustomTextField(
                    controller: idcardController,
                    hintText: 'ID No.',
                    validator: (value) {
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      text: "รูปบัตรประชาชน",
                      style: TextStyle(
                        color: Colors.black.withOpacity(1.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  /*
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
                                    'Select Images',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),*/
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      text: "จังหวัดที่ตั้งของร้านค้า",
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
                        value: selectedProvinceId,
                        onChanged: (String? newVal) {
                          setState(() {
                            selectedProvinceId = newVal!;
                          });
                        },
                        items: provinces.map((province) {
                          return DropdownMenuItem<String>(
                            value: province.id,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(province.provinceThai),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomButton(
                    text: 'ยืนยันการสร้างร้านค้า',
                    onTap: sellProduct,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
