import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kmutnb_project/constants/utills.dart';
import 'package:kmutnb_project/features/auth/widgets/constants.dart';
import 'package:kmutnb_project/features/myprofile/screens/user_profile_screen.dart';
import 'package:provider/provider.dart';

import '../../../constants/global_variables.dart';
import '../../../models/user.dart';
import '../../../providers/user_provider.dart';
import '../services/profile_service.dart';

class EditProfilePage extends StatefulWidget {
  static const routeName = '/edit_profile_user';
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    User user = userProvider.user;

    _fullNameController.text = user.fullName;
    _phoneNumberController.text = user.phoneNumber;
    _addressController.text = user.address;
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
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  ProfileService profileService = ProfileService();
  void _saveChanges() {
    String fullName = _fullNameController.text;
    String phoneNumber = _phoneNumberController.text;
    String address = _addressController.text;

    profileService.updateUser(
      address: address,
      context: context,
      fullName: fullName,
      phoneNumber: phoneNumber,
      productImage_: _selectedImage,
      select: false,
    );

    if (_selectedImage != null) {
      profileService.updateUser(
        address: address,
        context: context,
        fullName: fullName,
        phoneNumber: phoneNumber,
        productImage_: _selectedImage,
        select: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          title: const Text('แก้ไขโปรไฟล์'),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (userProvider.user.image == '' && _selectedImage == null) ...[
                GestureDetector(
                  onTap: () async {
                    File? image = await pickOneImage();
                    setState(() {
                      _selectedImage = image;
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
                ),
              ] else if (userProvider.user.image != '' &&
                  _selectedImage == null) ...[
                GestureDetector(
                  onTap: () async {
                    File? image = await pickOneImage();
                    setState(() {
                      _selectedImage = image;
                    });
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: kPrimaryColor,
                    child: ClipOval(
                      child: Image.network(
                        userProvider.user.image,
                        fit: BoxFit.cover,
                        height: 100.0,
                        width: 100.0,
                      ),
                    ),
                  ),
                )
              ] else if (_selectedImage != null) ...[
                GestureDetector(
                  onTap: () async {
                    File? image = await pickOneImage();
                    setState(() {
                      _selectedImage = image;
                    });
                  },
                  child: ClipOval(
                    child: Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                      height: 100.0,
                      width: 100.0,
                    ),
                  ),
                )
              ],
              TextField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: 'ชื่อ นามสกุล'),
              ),
              TextField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(labelText: 'เบอร์โทรศัพท์'),
              ),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'ที่อยู่'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('ยืนยันการแก้ไข'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
