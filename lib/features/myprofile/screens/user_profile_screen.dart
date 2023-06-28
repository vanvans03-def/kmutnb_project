import 'package:flutter/material.dart';
import 'package:kmutnb_project/features/account/widgets/orders.dart';
import 'package:kmutnb_project/features/auth/screens/login_screen.dart';
import 'package:kmutnb_project/features/auth/widgets/constants.dart';
import 'package:provider/provider.dart';

import 'package:kmutnb_project/features/myprofile/screens/edit_profile_screen.dart';
import '../../../models/user.dart';
import '../../../providers/user_provider.dart';
import '../../account/screens/account_screen.dart';
import '../../account/services/account_service.dart';
import '../../auth/screens/auth_screen.dart';
import '../../auth/services/auth_service.dart';

class UserProfileScreen extends StatefulWidget {
  static const String routeName = '/user-profile-screen';

  const UserProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreen();
}

class _UserProfileScreen extends State<UserProfileScreen> {
  User? user;
  late UserProvider userProvider;
  bool shouldUpdateProfile = false;

  @override
  void initState() {
    super.initState();
    if (shouldUpdateProfile) {
      updateProfileData();
    } else {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      user = userProvider.user;
    }
  }

  void updateProfileData() {
    user = userProvider.user;
    shouldUpdateProfile = false; // Reset the flag variable
  }

  AccountServices accountServices = AccountServices();
  Future<void> logOutGoogle() async {
    await GoogleSignInApi.logout();

    // ignore: use_build_context_synchronously
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            if (user!.image == "") ...[
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blueGrey,
                child: Image.asset(
                  "assets/images/user.png",
                  color: Color.fromRGBO(255, 255, 255, 1),
                  height: 60,
                  width: 60,
                ),
              ),
            ] else ...[
              CircleAvatar(
                radius: 50,
                backgroundColor: kPrimaryColor,
                child: CircleAvatar(
                  radius: 45,
                  backgroundImage: NetworkImage(
                    user!.image,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 10),
            Text(
              user!.fullName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
                leading: const Icon(
                  Icons.person,
                  color: kPrimaryColor,
                ),
                title: const Text('แก้ไขโปรไฟล์ส่วนตัว'),
                onTap: () async {
                  final value = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfilePage()),
                  );
                  if (value != null) {
                    userProvider.setUserFromModel(value);
                    setState(() {
                      user = value;
                      shouldUpdateProfile =
                          true; // Set the flag variable to true
                      updateProfileData(); // Update the user data immediately
                    });
                  }
                }),
            const Divider(
              height: 2,
              thickness: 2,
              indent: 20,
              endIndent: 0,
            ),
            ListTile(
              leading: const Icon(
                Icons.history,
                color: kPrimaryColor,
              ),
              title: const Text('กดดูประวัติออเดอร์'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AccountScreen()),
                );
              },
            ),
            const Divider(
              height: 2,
              thickness: 2,
              indent: 20,
              endIndent: 0,
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: kPrimaryColor,
              ),
              title: const Text('ออกจากระบบ'),
              onTap: () {
                logOutGoogle();
                Provider.of<UserProvider>(context, listen: false).logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false,
                );
              },
            ),
            const Divider(
              height: 2,
              thickness: 2,
              indent: 20,
              endIndent: 0,
            ),
          ],
        ),
      ),
    );
  }
}
