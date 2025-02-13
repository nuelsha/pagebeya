import 'package:flutter/material.dart';
import 'package:pagebeya/data/provider/auth_provider.dart';
import 'package:pagebeya/data/provider/cart_provider.dart';
import 'package:pagebeya/data/services/cart_services.dart';
import 'package:pagebeya/data/provider/catagori_provider.dart';
import 'package:pagebeya/data/services/categoryService.dart';
import 'package:pagebeya/data/provider/prodact_provider.dart';
import 'package:pagebeya/data/services/prodact_services.dart';

import 'package:pagebeya/presentation/screens/cart_page.dart';
import 'package:pagebeya/presentation/screens/checkout.dart';
import 'package:pagebeya/presentation/screens/home_page.dart';
import 'package:pagebeya/presentation/screens/signup_screen.dart';
import 'package:pagebeya/presentation/screens/user_profile.dart';
import 'package:provider/provider.dart';
import 'presentation/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
          create: (_) => ProductProvider(ProductService()),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(CartService()),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoryProvider(CategoryService()),
        ),
      ],
      child: PagebeyaApp(),
    ),
  );
}

class PagebeyaApp extends StatelessWidget {
  const PagebeyaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pagebeya',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(230, 0, 0, 1),
          primary: const Color.fromRGBO(230, 0, 0, 1),
          onPrimary: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(230, 0, 0, 1),
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(230, 0, 0, 1),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4), // Sharper borders
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color.fromRGBO(230, 0, 0, 1),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color.fromRGBO(230, 0, 0, 1),
            side: BorderSide(color: Colors.white),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4), // Sharper borders
            ),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: const Color.fromRGBO(230, 0, 0, 1),
          foregroundColor: Colors.white,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      routes: {
        '/home': (context) => HomePage(),
        '/cart': (context) => CartPage(),
        '/profile': (context) => UserProfilePage(),
        '/checkout': (context) => CheckoutPage(),
        '/signup': (context) => SignUpScreen(),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}
