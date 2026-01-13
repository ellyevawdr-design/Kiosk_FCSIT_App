import 'package:flutter/material.dart';
import 'package:kiosk_fcsit/menupage/menu.dart';
import 'package:kiosk_fcsit/utils/widgets/cart_favorrite_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'payment_success_page.dart';
import 'dart:math';

class QRPaymentPage extends StatelessWidget {
  final String orderNo;
  final String paymentMethod;
  final bool isPickup;

  const QRPaymentPage({
    super.key,
    required this.orderNo,
    required this.paymentMethod,
    required this.isPickup,
  });

  double _getTotal(CartFavoriteManager manager) {
    double total = 0;
    for (var item in manager.cartItems) {
      final price = double.tryParse(
        item['price']!.replaceAll(RegExp(r'[^0-9.]'), ''),
      ) ?? 0;
      total += price;
    }
    return total;
  }

  Future<void> _completePayment() async {
    final manager = CartFavoriteManager.instance;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    // Determine status
    String status = isPickup ? "Prepare" : "Complete";

    await FirebaseFirestore.instance.collection('Orders').doc(orderNo).set({
      'OrderID': orderNo,
      'Menus': manager.cartItems.map((e) => e['name']).toList(),
      'Total': _getTotal(manager),
      'ReferenceID' : 'REF${Random().nextInt(999999999).toString().padLeft(9, '0')}',
      'TransactionID' : 'TXN${Random().nextInt(999999999).toString().padLeft(9, '0')}',
      'Username': user.displayName ?? "Guest",
      'PaymentMethod': paymentMethod,
      'Status': status,
      'Date': DateTime.now().toIso8601String(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final manager = CartFavoriteManager.instance;

    return Scaffold(
      appBar: AppBar(title: const Text("Scan to Pay")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Order No: $orderNo",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(
                      Icons.qr_code,
                      size: 220,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "RM ${_getTotal(manager).toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  await _completePayment();

                  // Navigate to order tracking page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PaymentSuccessPage(orderNo: orderNo)
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                child: const Text(
                  "Payment Completed",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
