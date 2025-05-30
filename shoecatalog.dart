import 'package:flutter/material.dart';
import 'package:first_project/shoe_detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_project/cart_page.dart';

class ShoeCatalogPage extends StatelessWidget {
  ShoeCatalogPage({super.key});

  Color? getColorFromName(String colorName) {
    switch (colorName.toLowerCase().trim()) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'grey':
        return Colors.grey;
      case 'brown':
        return Colors.brown;
      case 'orange':
        return Colors.orange;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Shoe Catalog",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart,color: Colors.white,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CartPage(),
                ),

              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Shoes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error Loading Shoes'));
          }

          final shoes = snapshot.data!.docs;

          return ListView.builder(
            itemCount: shoes.length,
            itemBuilder: (context, index) {
              var shoe = shoes[index];
              String description = shoe['Description'] ?? 'No description';
              String brand = shoe['Brand'] ?? '';
              String type = shoe['Shoes Type'] ?? '';
              String color = shoe['Shoes Color'] ?? '';
              String price = shoe['Price'] ?? '';
              String image = shoe['Image'] ?? '';

              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ShoeDetailPage(
                            brand: brand,
                            description: description,
                            colors: color,
                            type: type,
                            price: price,
                            image: image,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.network(
                              image,
                              width: 180,
                              height: 180,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                              const Icon(Icons.image_not_supported),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  description,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Available Colors: $color',
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: color
                                      .split(',')
                                      .map((colorName) => Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: getColorFromName(colorName),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.black),
                                    ),
                                  ))
                                      .toList(),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Price: $price',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.deepOrange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(thickness: 1),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
