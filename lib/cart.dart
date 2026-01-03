import 'package:flutter/material.dart';
import 'package:networkclan_kiosk_fcsit_app/utils/widgets/cart_favorrite_manager.dart';
import 'package:routemaster/routemaster.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final manager = CartFavoriteManager.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Routemaster.of(context).replace('/menu'),
        ),
      ),
      body: manager.cartItems.isEmpty
          ? const Center(child: Text("Cart is empty"))
          : ListView.builder(
              itemCount: manager.cartItems.length,
              itemBuilder: (context, index) {
                final item = manager.cartItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: item['image'] != null
                        ? Image.asset(item['image']!, width: 50, height: 50)
                        : const Icon(Icons.fastfood),
                    title: Text(item['title']!),
                    subtitle: Text(item['price']!),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          manager.removeFromCart(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
