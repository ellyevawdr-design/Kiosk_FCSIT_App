import 'package:flutter/material.dart';
import 'package:networkclan_kiosk_fcsit_app/payment_success_page.dart';
import 'package:networkclan_kiosk_fcsit_app/utils/widgets/cart_favorrite_manager.dart';
import 'qr_payment_page.dart';
import 'order_tracking_page.dart';

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({super.key});

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  final manager = CartFavoriteManager.instance;

  final String orderNo =
      "ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}";

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

  void _handlePayment(int method) {
    switch (method) {
      case 1:
        // Cash on Delivery
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                OrderTrackingPage(orderNo: orderNo, isPaid: false),
          ),
        );
        break;

      case 2:
        // Touch 'n Go
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => QRPaymentPage(orderNo: orderNo),
          ),
        );
        break;

      case 3:
        // DuitNow
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
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ===== APP BAR =====
      appBar: AppBar(
        title: const Text("Select Payment Method"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),

      // ===== BODY =====
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order No: $orderNo",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 12),

            _paymentCard(
              title: "Cash",
              icon: Icons.payments,
              method: 1,
            ),

            _paymentCard(
              title: "Touch 'n Go eWallet",
              icon: Icons.account_balance_wallet,
              method: 2,
            ),

            _paymentCard(
              title: "DuitNow QR",
              icon: Icons.qr_code,
              method: 3,
            ),

            const Spacer(),

            // ===== TOTAL SECTION =====
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "RM ${_getTotal().toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
