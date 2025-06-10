import 'package:first_project/database_helper.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'models/shoe.dart';
import 'cart_page.dart';
import 'shoe_detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user.dart';

class ShoeCatalogPage extends StatefulWidget {
  const ShoeCatalogPage({super.key});

  @override
  State<ShoeCatalogPage> createState() => _ShoeCatalogPageState();
}

class _ShoeCatalogPageState extends State<ShoeCatalogPage> {
  List<Shoe> _shoes = [];

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
  void initState() {
    super.initState();
    _loadShoes();
    _loadUsername();
  }

  void _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      var username = prefs.getString('username') ?? '';
      print(
          ''+username);
    });
  }

  void _loadShoes() async {
    final shoes = await DatabaseHelper.instance.getShoes();
    setState(() {
      _shoes = shoes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Shoe Catalog",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartPage()),
                );
              },
            ),
          ],
        ),
        body: _shoes.isEmpty
            ? const Center(child: Text("No Shoes Found"))
            : ListView.builder(
          itemCount: _shoes.length,
          itemBuilder: (context, index) {
            final shoe = _shoes[index];

            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ShoeDetailPage(
                          brand: shoe.brand,
                          description: shoe.name,
                          colors: "black,white",
                          type: "Sneaker",
                          price: shoe.price.toString(),
                          image:
                          'https://via.placeholder.com/180x180.png?text=Shoe', // use from db if you have
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
                            'https://via.placeholder.com/180x180.png?text=Shoe',
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
                                shoe.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Brand: ${shoe.brand}',
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    fontStyle: FontStyle.italic),
                              ),
                              const SizedBox(height: 5),
                              const Row(
                                children: [
                                  // Dummy colors
                                  CircleAvatar(
                                    backgroundColor: Colors.black,
                                    radius: 10,
                                  ),
                                  SizedBox(width: 5),
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 10,
                                    foregroundColor: Colors.black,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Price: ₹${shoe.price}',
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
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // For demo: insert test shoe
            final newShoe = Shoe(
              id: DateTime.now().millisecondsSinceEpoch,
              name: "Nike Air Max",
              brand: "Nike",
              price: 3999.0,
            );
            await DatabaseHelper.instance.insertShoe(newShoe);
            _loadShoes();

          },
          backgroundColor: Colors.black,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}


