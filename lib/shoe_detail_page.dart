import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project/cart.dart';
import 'package:first_project/cart_page.dart';


class ShoeDetailPage extends StatefulWidget {
  final String brand;
  final String description;
  final String colors;
  final String type;
  final String price;
  final String image;

  const ShoeDetailPage({
    Key? key,
    required this.brand,
    required this.description,
    required this.colors,
    required this.type,
    required this.price,
    required this.image,
  }) : super(key: key);

  @override
  State<ShoeDetailPage> createState() => _ShoeDetailPageState();
}

class _ShoeDetailPageState extends State<ShoeDetailPage> {
  bool _isAdding = false;

  Future<void> _addToCart() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login to add items to your cart.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Validate required fields
    if (widget.brand.isEmpty ||
        widget.description.isEmpty ||
        widget.colors.isEmpty ||
        widget.type.isEmpty ||
        widget.price.isEmpty ||
        widget.image.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Some shoe details are missing. Cannot add to cart.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isAdding = true;
    });

    try {
      // Add to local cart (optional)
      Cart.addItem(CartItem(
        image: widget.image,
        description: widget.description,
        colors: widget.colors,
        price: widget.price,
      ));

      // Add to Firestore cart
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .add({
        'brand': widget.brand,
        'description': widget.description,
        'colors': widget.colors,
        'type': widget.type,
        'price': widget.price,
        'image': widget.image,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('Item successfully added to Firestore cart for user: ${user.uid}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Added to cart'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Firebase error while adding to cart: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add to cart'),
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isAdding = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shoe Details'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Image.network(
              widget.image,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Shoe Details
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.description,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Available colors: ${widget.colors}',
                          style: const TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Price: ${widget.price}',
                          style: const TextStyle(
                            color: Colors.deepOrangeAccent,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    // Add to Bag Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isAdding ? null : _addToCart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isAdding
                            ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                            : const Text(
                          'Add to Bag',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
