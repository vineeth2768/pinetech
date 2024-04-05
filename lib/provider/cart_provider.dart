import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:pinetech/model/product.dart';

class CartProvider with ChangeNotifier {
  final List<Product> _cartItems = [];
  final int maxItems = 6; // Maximum items allowed in the cart

  List<Product> get cartItems => [..._cartItems];

  bool addToCart(Product product) {
    if (_cartItems.length < maxItems) {
      // Check if the product is already in the cart
      if (!_cartItems.contains(product)) {
        _cartItems.add(product);
        notifyListeners();
        return true; // Addition successful
      } else {
        log('Product is already in the cart.');
        return false; // Product already in cart
      }
    } else {
      log('Maximum items limit reached in the cart.');
      return false; // Maximum items limit reached
    }
  }

  void removeFromCart(Product product) {
    _cartItems.remove(product);
    notifyListeners();
  }
}
