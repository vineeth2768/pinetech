import 'package:flutter/material.dart';
import 'package:pinetech/provider/cart_provider.dart';
import 'package:pinetech/provider/product_provider.dart';
import 'package:pinetech/screen/cart_screen.dart';
import 'package:pinetech/screen/category_screen.dart';
import 'package:pinetech/screen/product_screen.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProductProvider>(
            create: (context) => ProductProvider()),
        ChangeNotifierProvider<CartProvider>(
            create: (context) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'PineTech Task',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (ctx) => const CategoriesScreen(),
          '/products': (ctx) => const ProductsScreen(),
          '/cart': (ctx) => const CartScreen(),
        },
      ),
    );
  }
}
