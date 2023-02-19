import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kmutnb_project/constants/global_variables.dart';
import 'package:kmutnb_project/features/admin/screens/admin_screen.dart';
import 'package:kmutnb_project/features/auth/screens/auth_screen.dart';
import 'package:kmutnb_project/features/auth/services/auth_service.dart';
import 'package:kmutnb_project/providers/user_provider.dart';
import 'package:kmutnb_project/router.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'common/widgets/bottom_bar.dart';
import 'models/product.dart';

final _http = http.Client();

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    getDataCategory();
  }

  Future<void> getDataCategory() async {
    var url = Uri.parse('https://node-api-beige.vercel.app/api/category');
    var res = await _http.get(url);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'KMUTNB Project',
        theme: ThemeData(
          scaffoldBackgroundColor: GlobalVariables.backgroundColor,
          colorScheme: const ColorScheme.light(
            primary: GlobalVariables.secondaryColor,
          ),
          appBarTheme: const AppBarTheme(
              elevation: 0,
              iconTheme: IconThemeData(
                color: Colors.black,
              )),
        ),
        onGenerateRoute: (settings) => generateRoute(settings),
        home: Provider.of<UserProvider>(context).user.token.isNotEmpty
            ? Provider.of<UserProvider>(context).user.type == 'user'
                ? const BottomBar()
                : const AdminScreen()
            : const AuthScreen());
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
