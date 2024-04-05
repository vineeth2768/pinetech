import 'dart:developer';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pinetech/model/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<String> _categories = [];
  bool _isLoading = false;

  List<Product> get products => [..._products];
  List<String> get categories => [..._categories];
  bool get isLoading => _isLoading;

  ProductProvider() {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response =
          await http.get(Uri.parse("https://dummyjson.com/products"));
      final responseData = json.decode(response.body);

      if (responseData is Map && responseData.containsKey('products')) {
        final List<dynamic> productsData = responseData['products'];
        final List<Product> loadedProducts = [];
        final List<String> loadedCategories = [];

        for (var productData in productsData) {
          final product = Product.fromJson(productData as Map<String, dynamic>);
          loadedProducts.add(product);
          if (!loadedCategories.contains(product.category)) {
            loadedCategories.add(product.category);
          }
        }

        _products = loadedProducts;
        _categories = loadedCategories;
      } else {
        log('Error fetching products: Response data is not in the expected format.');
      }
    } catch (error) {
      log('Error fetching products: $error');
    }
    _isLoading = false;
    notifyListeners();
  }
}
