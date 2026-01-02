import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import 'qr_payment_page.dart';
import 'order_tracking_page.dart';

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({super.key});

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  final cart = CartModel.instance;
  final String orderNo =
      "ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}";

  void _handlePayment(int method) {
    // Save selected payment method to CartModel
    switch (method) {
      case 1:
        cart.paymentMethod = "Cash on Delivery";
        // Navigate to order tracking page for COD
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => OrderTrackingPage(orderNo: orderNo, isPaid: false),
          ),
        );
        break;
      case 2:
        cart.paymentMethod = "Touch 'n Go eWallet";
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => QRPaymentPage(orderNo: orderNo),
          ),
        );
        break;
      case 3:
        cart.paymentMethod = "DuitNow QR";
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => QRPaymentPage(orderNo: orderNo),
          ),
        );
        break;
    }
  }

  Widget _paymentCard({
    required String title,
    required IconData icon,
    required int method,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        onTap: () => _handlePayment(method),
        leading: Icon(icon, size: 36, color: Colors.blue),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Payment Method"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Order No: $orderNo",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            _paymentCard(title: "Cash on Delivery", icon: Icons.payments, method: 1),
            _paymentCard(title: "Touch 'n Go eWallet", icon: Icons.account_balance_wallet, method: 2),
            _paymentCard(title: "DuitNow QR", icon: Icons.qr_code, method: 3),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text("RM ${cart.total.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
