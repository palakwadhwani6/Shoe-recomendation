import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Bag')),
        body: const Center(
          child: Text('Please log in to see your cart.'),
        ),
      );
    }

    // Reference to the cart collection (for deletions)
    final cartCollectionRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('cart');

    // Query to listen to ordered cart items
    final cartQuery = cartCollectionRef.orderBy('timestamp', descending: true);

    return Scaffold(
      appBar: AppBar(title: const Text('My Bag')),
      body: StreamBuilder<QuerySnapshot>(
        stream: cartQuery.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading cart items'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final cartDocs = snapshot.data?.docs ?? [];

          if (cartDocs.isEmpty) {
            return const Center(child: Text("Your bag is empty"));
          }

          return ListView.builder(
            itemCount: cartDocs.length,
            itemBuilder: (context, index) {
              final doc = cartDocs[index];
              final data = doc.data()! as Map<String, dynamic>;

              final description = data['description'] ?? '';
              final colors = data['colors'] ?? '';
              final price = data['price'] ?? '';
              final image = data['image'] ?? '';

              return ListTile(
                leading: image != ''
                    ? Image.network(image, width: 50, height: 50, fit: BoxFit.cover)
                    : null,
                title: Text(description),
                subtitle: Text("Color: $colors"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("$price"),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () async {
                          try {
                            // Use collection ref here to delete document by id
                            await cartCollectionRef.doc(doc.id).delete();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Item removed from cart')),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Failed to remove item')),
                            );
                          }
                        },
                        child: const Icon(Icons.clear),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
