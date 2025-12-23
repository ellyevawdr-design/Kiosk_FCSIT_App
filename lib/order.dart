import 'package:flutter/material.dart';

class Order extends StatelessWidget {
  const Order({super.key});

  static const Color primary = Color(0xFF2B6CB0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: const Text("Order Summary"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Order",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // Example order item
            const Card(
              child: ListTile(
                title: Text("Nasi Lemak"),
                subtitle: Text("RM 4.00"),
                trailing: Text("x1"),
              ),
            ),

            const Spacer(),

            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Total:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "RM 4.00",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Confirm button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text("Confirm Order"),
            ),
          ],
        ),
      ),
    );
  }
}
