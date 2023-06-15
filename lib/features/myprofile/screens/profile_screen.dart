import 'package:flutter/material.dart';
import 'package:kmutnb_project/features/account/widgets/orders.dart';
import 'package:provider/provider.dart';

import 'package:kmutnb_project/features/myprofile/screens/edit_profile_screen.dart';
import '../../../models/user.dart';
import '../../../providers/user_provider.dart';
import '../../account/screens/account_screen.dart';
import 'edite_store_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/user-profile-screen';

  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  User? user;
  @override
  void initState() {
    super.initState();

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    user = userProvider.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
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
                  backgroundImage: NetworkImage(
                    user!.image,
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
                leading: const Icon(Icons.person),
                title: const Text('แก้ไขโปรไฟล์ส่วนตัว'),
                onTap: () async {
                  final value = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfilePage(),
                    ),
                  );
                  if (value != null) {
                    setState(() {
                      user = value;
                    });
                  }
                },
              ),
              const Divider(
                height: 2,
                thickness: 2,
                indent: 20,
                endIndent: 0,
              ),
              ListTile(
                leading: const Icon(Icons.store),
                title: const Text('แก้ไขโปรไฟล์ร้านค้า'),
                onTap: () async {
                  final value = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditeStoreScreen(),
                    ),
                  );
                  if (value != null) {
                    setState(() {
                      user = value;
                    });
                  }
                },
              ),
              const Divider(
                height: 2,
                thickness: 2,
                indent: 20,
                endIndent: 0,
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('กดดูประวัติออร์เดอร์'),
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
                leading: const Icon(Icons.logout),
                title: const Text('ออกจากระบบ'),
                onTap: () {
                  // ทำงานเมื่อกดออกจากระบบ
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
      ),
    );
  }
}
