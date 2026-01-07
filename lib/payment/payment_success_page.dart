import 'package:flutter/material.dart';
import 'order_tracking_page.dart';

class PaymentSuccessPage extends StatelessWidget {
  final String orderNo;
  const PaymentSuccessPage({super.key, required this.orderNo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle,
                  size: 120, color: Colors.green),
              const SizedBox(height: 16),
              const Text("Payment Successful",
                  style:
                      TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text("Order No: $orderNo"),
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
                            OrderTrackingPage(orderNo: orderNo, isPaid: true),
                      ),
                    );
                  },
                  child: const Text("Track Order"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
