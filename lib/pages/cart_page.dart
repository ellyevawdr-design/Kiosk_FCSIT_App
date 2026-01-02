import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import 'checkout_page.dart';
import 'menu_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final cart = CartModel.instance;

  // Map food names to image assets
  String getImageForItem(String name) {
    switch (name) {
      case "Beef Sandwich":
        return "assets/images/beef_sandwich.png";
      case "Ham Sandwich":
        return "assets/images/ham_sandwich.png";
      case "Cheese Sandwich":
        return "assets/images/cheese_sandwich.png";
      default:
        return "assets/images/default_food.png"; // fallback image
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // No blue coloring
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Your Cart",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "FCSIT (UNIMAS)",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: cart.items.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cart.items.length + 4, // items + add another + total + cutlery title + cutlery row
              itemBuilder: (context, index) {
                if (index < cart.items.length) {
                  final item = cart.items[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          getImageForItem(item.name),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(item.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Quantity: ${item.quantity}"),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                cart.items.removeAt(index);
                              });
                            },
                            child: const Text(
                              "Remove Item",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      trailing: Text(
                          "RM ${(item.price * item.quantity).toStringAsFixed(2)}",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  );
                } else if (index == cart.items.length) {
                  // "Add Another Item" button
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const MenuPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Add Another Item",
                          style: TextStyle(fontSize: 16)),
                    ),
                  );
                } else if (index == cart.items.length + 1) {
                  // Total section
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ListTile(
                      title: const Text("Total",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      trailing: Text("RM ${cart.total.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  );
                } else if (index == cart.items.length + 2) {
                  // "Add Cutlery" title
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      "Add Cutlery",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  );
                } else {
                  // Cutlery row using CartModel's cutleryAdded
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.restaurant, size: 32),
                      title: const Text("Need Cutlery?"),
                      trailing: SizedBox(
                        width: 100,
                        height: 36,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              cart.cutleryAdded = !cart.cutleryAdded;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.black,
                            shadowColor: Colors.transparent,
                          ),
                          child: Text(
                            cart.cutleryAdded ? "Added" : "Add",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton(
          onPressed: cart.items.isEmpty
              ? null
              : () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CheckoutPage())),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: Colors.lightBlue.shade300,
          ),
          child: const Text(
            "Review Payment",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}