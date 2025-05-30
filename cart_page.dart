import 'package:flutter/material.dart';
import 'package:first_project/cart.dart';

class CartPage extends StatefulWidget{
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Bag')),
      body: Cart.items.isEmpty?
          const Center(child: Text("Your bag is empty"))
          : ListView.builder(itemCount: Cart.items.length,
      itemBuilder: (context,index){
            final item = Cart.items[index];
            return ListTile(
              title: Text(item.description),
              subtitle: Text("Color:${item.colors}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("${item.price}"),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          Cart.removeItem(index);
                        });
                      },
                        child: Icon(Icons.clear)),
                  )
                ],
              ),
            );
      }
      ),
    );
  }
}