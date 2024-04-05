import 'package:flutter/material.dart';
import 'package:pinetech/model/product.dart';
import 'package:pinetech/provider/cart_provider.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<Product> _cartItems;
  late Map<String, Offset> _productPositions;
  late double _containerWidth;
  late double _containerHeight;
  late double _zoomScale = 1.0; // Initialize zoom scale

  @override
  void initState() {
    super.initState();
    _cartItems = Provider.of<CartProvider>(context, listen: false).cartItems;
    _productPositions = {};
    _initializeProductPositions();
  }

  void _initializeProductPositions() {
    for (int i = 0; i < _cartItems.length; i++) {
      _productPositions['product_$i'] = Offset(i * 120.0, i * 120.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                _containerWidth = constraints.maxWidth;
                _containerHeight = constraints.maxHeight;
                return Container(
                  width: double.infinity,
                  height: 600,
                  color: Colors.grey[200],
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        _productPositions.forEach((key, value) {
                          double newX = value.dx + details.delta.dx;
                          double newY = value.dy + details.delta.dy;
                          newX = newX.clamp(0, _containerWidth - 100);
                          newY = newY.clamp(0, _containerHeight - 100);
                          _productPositions[key] = Offset(newX, newY);
                        });
                      });
                    },
                    child: Stack(
                      children: [
                        for (var product in _cartItems)
                          _buildDraggableItem(product),
                      ],
                    ),
                  ),
                );
              },
            ),
            const Spacer(),
            const Icon(Icons.pan_tool),
            const Text(
                "1.Drag products rearrange the order\n2.Tab and hold to move an Products\n3.Tab the product to zoom")
          ],
        ),
      ),
    );
  }

  Widget _buildDraggableItem(Product product) {
    Offset position = _productPositions[product.id.toString()] ?? Offset.zero;

    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Stack(
        children: [
          Draggable(
            data: product,
            feedback: Material(
              elevation: 4.0,
              child: SizedBox(
                width: 100,
                height: 100,
                child: InteractiveViewer(
                  boundaryMargin: const EdgeInsets.all(50),
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Image.network(
                    product.images.isNotEmpty ? product.images[0] : '',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            childWhenDragging: SizedBox(
              width: 100,
              height: 100,
              child: Container(),
            ),
            onDraggableCanceled: (velocity, offset) {
              double newX = offset.dx.clamp(0, _containerWidth - 100);
              double newY = offset.dy.clamp(0, _containerHeight - 100);
              setState(() {
                _productPositions[product.id.toString()] = Offset(newX, newY);
              });
            },
            child: SizedBox(
              width: 100,
              height: 100,
              child: GestureDetector(
                onTap: () {
                  _onProductTap(product.id.toString());
                },
                child: Transform.scale(
                  scale: _zoomScale,
                  child: Image.network(
                    product.images.isNotEmpty ? product.images[0] : '',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.remove_circle),
              onPressed: () {
                Provider.of<CartProvider>(context, listen: false)
                    .removeFromCart(product);
                // Remove the product from the local list and update UI
                setState(() {
                  _cartItems.remove(product);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product.title} removed from the cart'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onProductTap(String productId) {
    setState(() {
      // Toggle zoom in/out for the tapped product
      _zoomScale = (_zoomScale == 1.0) ? 2.0 : 1.0;
    });
  }
}
