import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kmutnb_project/features/myprofile/services/profile_service.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/custom_textfield.dart';
import '../../../common/widgets/customer_button.dart';
import '../../../models/province.dart';
import '../../../providers/store_provider.dart';
import '../../store/services/add_store_service.dart';

class EditeStoreScreen extends StatefulWidget {
  static const routeName = '/edite_store_screen';
  const EditeStoreScreen({super.key});

  @override
  State<EditeStoreScreen> createState() => _EditeStoreScreenState();
}

class _EditeStoreScreenState extends State<EditeStoreScreen> {
  final TextEditingController storeNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  File? _selectedImageCover;
  File? _selectedImageProfile;
  List<Province> provinces = [];
  String selectedProvinceId = '';
  final _addStoreFormKey = GlobalKey<FormState>();
  final ProvinceService provinceService = ProvinceService();
  @override
  void initState() {
    super.initState();
    _getProvinces();
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    final store = storeProvider.store;
    storeNameController.text = store.storeName;
    _phoneNumberController.text = store.phone;
    descriptionController.text = store.storeDescription;
  }

  void _getProvinces() async {
    provinces = await provinceService.fetchAllProvince(context);
    selectedProvinceId = provinces.first.id;

    setState(() {});
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
    return image;
  }

  @override
  void dispose() {
    storeNameController.dispose();
    descriptionController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void editeStore() {
    ProfileService profileService = ProfileService();
    if (_addStoreFormKey.currentState!.validate() &&
        _selectedImageCover != null &&
        _selectedImageProfile != null) {
      profileService.updateStore(
        bannerImage_: _selectedImageCover,
        context: context,
        phone: _phoneNumberController.text,
        profiletImage_: _selectedImageProfile,
        province: selectedProvinceId,
        selectBanner: true,
        selectProfile: true,
        storeDescription: descriptionController.text,
        storename: storeNameController.text,
      );

      setState(() {});
    } else if (_addStoreFormKey.currentState!.validate() &&
        _selectedImageCover == null &&
        _selectedImageProfile != null) {
      profileService.updateStore(
        bannerImage_: _selectedImageCover,
        context: context,
        phone: _phoneNumberController.text,
        profiletImage_: _selectedImageProfile,
        province: selectedProvinceId,
        selectBanner: false,
        selectProfile: true,
        storeDescription: descriptionController.text,
        storename: storeNameController.text,
      );

      setState(() {});
    } else if (_addStoreFormKey.currentState!.validate() &&
        _selectedImageProfile == null &&
        _selectedImageCover != null) {
      profileService.updateStore(
        bannerImage_: _selectedImageCover,
        context: context,
        phone: _phoneNumberController.text,
        profiletImage_: _selectedImageProfile,
        province: selectedProvinceId,
        selectBanner: true,
        selectProfile: false,
        storeDescription: descriptionController.text,
        storename: storeNameController.text,
      );

      setState(() {});
    } else if (_selectedImageCover == null && _selectedImageProfile == null) {
      profileService.updateStore(
        bannerImage_: _selectedImageCover,
        context: context,
        phone: _phoneNumberController.text,
        profiletImage_: _selectedImageProfile,
        province: selectedProvinceId,
        selectBanner: false,
        selectProfile: false,
        storeDescription: descriptionController.text,
        storename: storeNameController.text,
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

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    final store = storeProvider.store;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edite Store Profile'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // background image and bottom contents
          Column(
            children: <Widget>[
              Container(
                child: Column(
                  children: [
                    if (store.banner == '' && _selectedImageCover == null) ...[
                      GestureDetector(
                        onTap: () async {
                          File? image = await pickOneImage();
                          setState(() {
                            _selectedImageCover = image;
                          });
                        },
                        child: Container(
                          height: 150.0,
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                size: 40,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Add Banner',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ] else if (store.banner != '' &&
                        _selectedImageCover == null) ...[
                      GestureDetector(
                        onTap: () async {
                          File? image = await pickOneImage();
                          setState(() {
                            _selectedImageCover = image;
                          });
                        },
                        child: Container(
                          height: 150.0,
                          color: Colors.orange,
                          child: Image.network(
                            store.banner,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    ] else if (_selectedImageCover != null) ...[
                      GestureDetector(
                        onTap: () async {
                          File? image = await pickOneImage();
                          setState(() {
                            _selectedImageCover = image;
                          });
                        },
                        child: Container(
                          height: 150.0,
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                          ),
                          child: Image.file(
                            _selectedImageCover!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    ],
                  ],
                ),
              ),
              Container(
                child: Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Container(
                      margin: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: SingleChildScrollView(
                          child: Form(
                              key: _addStoreFormKey,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
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
                                      controller: _phoneNumberController,
                                      hintText: 'Phone number',
                                      validator: (value) {
                                        return null;
                                      },
                                    ),
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
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child:
                                                    Text(province.provinceThai),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    CustomButton(
                                      text: 'ยืนยันการแก้ไขร้านค้า',
                                      onTap: editeStore,
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          // Profile image
          Positioned(
            top: 100.0, // (background container size) - (circle height / 2)
            child: Container(
              height: 100.0,
              width: 100.0,
              child: _buildPositionedImage(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPositionedImage() {
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    final store = storeProvider.store;
    if (store.storeImage == '' && _selectedImageProfile == null) {
      return GestureDetector(
        onTap: () async {
          File? image = await pickOneImage();
          setState(() {
            _selectedImageProfile = image;
          });
        },
        child: const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.blueGrey,
          child: Icon(
            Icons.add_a_photo,
            size: 40,
            color: Colors.white,
          ),
        ),
      );
    } else if (store.storeImage != '' && _selectedImageProfile == null) {
      return GestureDetector(
        onTap: () async {
          File? image = await pickOneImage();
          setState(() {
            _selectedImageProfile = image;
          });
        },
        child: CircleAvatar(
          backgroundColor: Colors.teal,
          radius: 50,
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              store.storeImage,
            ),
            radius: 45,
          ),
        ),
      );
    } else if (_selectedImageProfile != null) {
      return GestureDetector(
        onTap: () async {
          File? image = await pickOneImage();
          setState(() {
            _selectedImageProfile = image;
          });
        },
        child: CircleAvatar(
          radius: 50,
          backgroundColor: Colors.blueGrey,
          child: CircleAvatar(
            radius: 45,
            backgroundImage: FileImage(
              _selectedImageProfile!,
            ),
          ),
        ),
      );
    } else {
      return Container(); // ถ้าไม่ใช่เงื่อนไขใดเลยให้คืนค่า Container ว่าง
    }
  }
}
