import 'package:flutter/material.dart';
import 'package:kmutnb_project/common/widgets/bottom_bar.dart';
import 'package:kmutnb_project/features/address/screens/addres_screen.dart';
import 'package:kmutnb_project/features/auth/screens/auth_screen.dart';
import 'package:kmutnb_project/features/chat/screens/StoreChatPage.dart';
import 'package:kmutnb_project/features/home/screens/category_deals_screen.dart';
import 'package:kmutnb_project/features/home/widgets/map_screen.dart';
import 'package:kmutnb_project/features/myprofile/screens/profile_screen.dart';
import 'package:kmutnb_project/features/product_details/screens/product_deatails_screen.dart';
import 'package:kmutnb_project/features/search/screens/search_screen.dart';
import 'package:kmutnb_project/models/ChatModel.dart';
import 'package:kmutnb_project/models/orderStore.dart';
import 'package:kmutnb_project/models/product.dart';

import 'features/admin/screens/add_products_screen.dart';
import 'features/admin/screens/admin_screen.dart';
import 'features/admin/screens/edit_products_screen.dart';
import 'features/admin/screens/store_category_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/signup_screen.dart';
import 'features/chat/screens/ChatPage.dart';
import 'features/chat/screens/chat_history_screen.dart';
import 'features/chat/screens/chat_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/myprofile/screens/edit_profile_screen.dart';
import 'features/myprofile/screens/edite_store_screen.dart';
import 'features/myprofile/screens/user_profile_screen.dart';
import 'features/order_detail/screens/order_details.dart';
import 'features/order_detail/screens/order_store_details.dart';
import 'features/store/screens/add_store_screen.dart';
import 'models/order.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen(),
      );

    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );

    case ProfileScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ProfileScreen(),
      );
    case BottomBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BottomBar(),
      );

    case AddProductScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddProductScreen(),
      );
    case EditProductScreen.routeName:
      var product = routeSettings.arguments as Product;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => EditProductScreen(
          productData: product,
        ),
      );
    case AddStoreScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddStoreScreen(),
      );
    case AdminScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AdminScreen(),
      );
    case CategoryDealsScreen.routeName:
      var category = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => CategoryDealsScreen(
          category: category,
        ),
      );
    case StoreCategoryScreen.routeName:
      var category = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => StoreCategoryScreen(
          category: category,
        ),
      );
    case SearchScreen.routeName:
      var searchQuery = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SearchScreen(
          searchQuery: searchQuery,
        ),
      );
    case ProductDetailScreen.routeName:
      var product = routeSettings.arguments as Product;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ProductDetailScreen(
          product: product,
        ),
      );
    case AddressScreen.routeName:
      var totalAmount = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AddressScreen(
          totalAmount: totalAmount,
        ),
      );
    case MapScreen.routeName:
      var currentLat = routeSettings.arguments as double;
      var currentLng = routeSettings.arguments as double;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => MapScreen(
          currentLat: currentLat,
          currentLng: currentLng,
        ),
      );
    case OrderDetailScreen.routeName:
      var order = routeSettings.arguments as Order;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => OrderDetailScreen(
          order: order,
        ),
      );
    case OrderStoreDetailScreen.routeName:
      var order = routeSettings.arguments as OrderStore;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => OrderStoreDetailScreen(
          order: order,
        ),
      );
    case ChatScreen.routeName:
      final args = routeSettings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ChatScreen(
          chatName: args['chatName'],
          receiverId: args['receiverId'],
          senderId: args['senderId'],
          image: args['image'],
        ),
      );

    case ChatPage.routeName:
      var arguments = routeSettings.arguments;
      if (arguments is ChatModel) {
        // ignore: unnecessary_cast
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const ChatPage(),
        );
      } else {
        throw Exception("Invalid arguments for ChatPage");
      }
    case StoreChatPage.routeName:
      var arguments = routeSettings.arguments;
      if (arguments is ChatModel) {
        // ignore: unnecessary_cast
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const StoreChatPage(),
        );
      } else {
        throw Exception("Invalid arguments for ChatPage");
      }
    case ChatHistoryScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ChatHistoryScreen(),
      );
    case EditProfilePage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => EditProfilePage(),
      );

    case SignUpScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SignUpScreen(),
      );
    case LoginScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const LoginScreen(),
      );
    case EditeStoreScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const EditeStoreScreen(),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const LoginScreen(),
      );
  }
}
