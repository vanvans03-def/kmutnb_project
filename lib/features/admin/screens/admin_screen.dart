import 'package:flutter/material.dart';
import 'package:kmutnb_project/features/admin/screens/orders_screen.dart';
import 'package:kmutnb_project/features/admin/screens/post_screen.dart';
import 'package:kmutnb_project/providers/store_provider.dart';
import 'package:provider/provider.dart';
import '../../../constants/global_variables.dart';
import '../../../providers/user_provider.dart';
import '../../chat/screens/ChatPage.dart';
import '../../myprofile/screens/profile_screen.dart';
import 'analtyics_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});
  static const String routeName = '/admin-screen';
  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;
  get user => Provider.of<UserProvider>(context).user;

  List<Widget> pages = [
    const PostScreen(),
    const AnalyticsScreen(),
    const OrderScreen(),
    const ProfileScreen(),
  ];

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    final storeName = storeProvider.store.storeName;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          elevation: 2.0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: GlobalVariables.appBarGradientStore,
              borderRadius: const BorderRadius.only(),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // เปลี่ยนสีเงาที่นี่
                  offset: Offset(0, 5.0),

                  blurRadius: 4.0,
                )
              ],
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (storeProvider.store.storeImage == '') ...[
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    backgroundColor: Colors.blueGrey,
                    radius: 22,
                    child: Icon(
                      Icons.store,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ] else ...[
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 25,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      storeProvider.store.storeImage,
                    ),
                    radius: 22,
                  ),
                ),
              ],
              Expanded(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    storeName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                height: 42,
                margin: const EdgeInsets.symmetric(horizontal: 0),
                child: IconButton(
                  icon: const Icon(
                    Icons.chat,
                    color: Colors.black,
                    size: 25,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        backgroundColor: GlobalVariables.backgroundColor,
        iconSize: 28,
        onTap: updatePage,
        items: [
          // Post
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 0
                        ? GlobalVariables.selectedNavBarColor
                        : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(
                Icons.house,
              ),
            ),
            label: '',
          ),
          // Anylatic
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 1
                        ? GlobalVariables.selectedNavBarColor
                        : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(
                Icons.analytics_outlined,
              ),
            ),
            label: '',
          ),
          // ORder
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 2
                        ? GlobalVariables.selectedNavBarColor
                        : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(
                Icons.all_inbox_outlined,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 3
                        ? GlobalVariables.selectedNavBarColor
                        : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(
                Icons.person_3_outlined,
              ),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
