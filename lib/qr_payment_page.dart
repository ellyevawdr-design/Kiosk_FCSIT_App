import 'package:flutter/material.dart';
import 'package:networkclan_kiosk_fcsit_app/models/cart_model.dart';
import 'payment_success_page.dart';

class QRPaymentPage extends StatelessWidget {
  final String orderNo;
  const QRPaymentPage({super.key, required this.orderNo});

  @override
  Widget build(BuildContext context) {
    final cart = CartModel.instance;

    return Scaffold(
      appBar: AppBar(title: const Text("Scan to Pay")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Order No: $orderNo",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            Card(
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(Icons.qr_code, size: 220, color: Colors.blue),
                    const SizedBox(height: 16),
                    Text(
                      "RM ${cart.total.toStringAsFixed(2)}",
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
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            PaymentSuccessPage(orderNo: orderNo)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Payment Completed",
                    style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
