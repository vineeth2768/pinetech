import 'package:flutter/material.dart';
import 'package:pinetech/model/product.dart';
import 'package:pinetech/provider/cart_provider.dart';
import 'package:pinetech/provider/product_provider.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context)!.settings.arguments as String;
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final products = productProvider.products
        .where((product) => product.category == category)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
            icon: const Icon(Icons.shopping_cart),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (ctx, index) {
          final Product product = products[index];
          final String firstImage =
              product.images.isNotEmpty ? product.images[0] : '';

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.network(
                    firstImage,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  product.title,
                  style: const TextStyle(fontSize: 16),
                ),
                trailing: IconButton(
                  onPressed: () {
                    if (cartProvider.cartItems.length < cartProvider.maxItems) {
                      bool addedToCart = cartProvider.addToCart(product);
                      if (addedToCart) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Added to Cart'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Item is already in the cart.'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Maximum items limit reached in the cart.'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.add),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
