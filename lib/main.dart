import 'package:e_commerce_app/binding_page.dart';
import 'package:e_commerce_app/screens/favorite_screen.dart';
import 'package:e_commerce_app/screens/registration_screen.dart';
import 'package:e_commerce_app/screens/splash_scren.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'screens/login_screen.dart';
import 'screens/product_list_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Commerce App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialBinding: InitialBinding(),
      // ignore: unrelated_type_equality_checks
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/splash', page: () => SplashScreen()),
        GetPage(name: '/productList', page: () => ProductListScreen()),
        GetPage(name: '/favorites', page: () => FavoritesScreen()),
        GetPage(name: '/registration', page: () => RegisterScreen()),
        GetPage(name: '/profile', page: () => ProfileScreen()),
      ],
    );
  }
}
