import 'package:flutter/material.dart';
import 'package:kiosk_fcsit/utils/widgets/cart_favorrite_manager.dart';
import 'package:kiosk_fcsit/menupage/menu.dart';
import '../order.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final manager = CartFavoriteManager.instance;

  double _getTotal() {
    double total = 0;
    for (var item in manager.cartItems) {
      final price =
          double.tryParse(item['price']!.replaceAll(RegExp(r'[^0-9.]'), '')) ??
          0;
      total += price;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ===== APP BAR =====
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const Menu()),
          ),
        ),
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
              "FCSIT",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ),

      // ===== BODY =====
      body: manager.cartItems.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: manager.cartItems.length + 2,
              itemBuilder: (context, index) {
                // ===== CART ITEMS =====
                if (index < manager.cartItems.length) {
                  final item = manager.cartItems[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child:
                            item['image'] != null && item['image']!.isNotEmpty
                            ? Image.asset(
                                item['image']!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.fastfood, size: 40),
                      ),
                      title: Text(
                        item['name'] ?? 'Unnamed item',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: GestureDetector(
                        onTap: () {
                          setState(() {
                            manager.removeFromCart(index);
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(top: 6),
                          child: Text(
                            "Remove Item",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      trailing: Text(
                        item['price'] ?? 'RM 0.00',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }

                // ===== ADD ANOTHER ITEM BUTTON =====
                if (index == manager.cartItems.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Menu()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.blue.shade100,
                        foregroundColor: Colors.black,
                        elevation: 0,
                      ),
                      child: const Text(
                        "Add Another Item",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                }

                // ===== TOTAL SECTION =====
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    "Total",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  trailing: Text(
                    "RM ${_getTotal().toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),

      // ===== BOTTOM BUTTON =====
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: manager.cartItems.isEmpty
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const OrderPage()),
                    );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue.shade400,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Review Payment",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
