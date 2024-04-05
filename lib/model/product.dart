import 'dart:ui';

class Product {
  int id;
  String title;
  String category;
  List<String> images;
  Offset position;

  Product({
    required this.id,
    required this.title,
    required this.category,
    required this.images,
    this.position = Offset.zero,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      images: List<String>.from(json['images']),
    );
  }
}
