import 'package:flutter/material.dart';
import 'package:pinetech/provider/product_provider.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final categories = productProvider.categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (ctx, index) => ListTile(
          title: Text(categories[index]),
          onTap: () {
            Navigator.of(context).pushNamed(
              '/products',
              arguments: categories[index],
            );
          },
        ),
      ),
    );
  }
}
