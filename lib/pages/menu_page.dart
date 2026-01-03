import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import 'cart_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final cart = CartModel.instance;

  void _addToCart(String name, double price) {
    setState(() {
      final index = cart.items.indexWhere((item) => item.name == name);
      if (index != -1) {
        cart.items[index] = CartItem(
            name: name,
            price: price,
            quantity: cart.items[index].quantity + 1);
      } else {
        cart.items.add(CartItem(name: name, price: price, quantity: 1));
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$name added to cart")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Good Meal")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _foodCard("Beef Sandwich", 3.00),
          _foodCard("Ham Sandwich", 3.00),
          _foodCard("Cheese Sandwich", 3.00),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton(
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => const CartPage())),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text("View Cart", style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }

  Widget _foodCard(String name, double price) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ListTile(
        leading: const Icon(Icons.fastfood, size: 40, color: Colors.blue),
        title: Text(name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text("RM ${price.toStringAsFixed(2)}"),
        trailing: IconButton(
          icon: const Icon(Icons.add_circle, color: Colors.blue, size: 28),
          onPressed: () => _addToCart(name, price),
        ),
      ),
    );
  }
}
