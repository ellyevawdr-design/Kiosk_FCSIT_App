import 'package:flutter/material.dart';
import 'package:kiosk_fcsit/utils/widgets/cart_favorrite_manager.dart';
import 'package:kiosk_fcsit/payment/payment_method_page.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  double _getTotal() {
    double total = 0;
    for (var item in CartFavoriteManager.instance.cartItems) {
      final price =
          double.tryParse(item['price']!.replaceAll(RegExp(r'[^0-9.]'), '')) ??
              0;
      total += price;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final manager = CartFavoriteManager.instance;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Order Summary",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: manager.cartItems.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: manager.cartItems.length + 1,
              itemBuilder: (context, index) {
                if (index < manager.cartItems.length) {
                  final item = manager.cartItems[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: item['image'] != null && item['image']!.isNotEmpty
                          ? Image.asset(item['image']!,
                              width: 50, height: 50, fit: BoxFit.cover)
                          : const Icon(Icons.fastfood, size: 40),
                      title: Text(item['name'] ?? 'Unnamed Item',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text("Qty: 1"),
                      trailing: Text(item['price'] ?? 'RM 0.00',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  );
                }

                // Total
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("RM ${_getTotal().toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: manager.cartItems.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // go to payment page, order type is already in CartFavoriteManager
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => PaymentMethodPage(
                              orderNo:
                                  "ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue.shade400,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: const Text("Select Payment Method",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ),
            ),
    );
  }
}
