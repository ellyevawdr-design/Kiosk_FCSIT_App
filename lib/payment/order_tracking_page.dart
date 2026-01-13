import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderTrackingPage extends StatefulWidget {
  final String orderNo;
  final String initialStatus;
  final bool isPaid;

  const OrderTrackingPage({
    super.key,
    required this.orderNo,
    required this.initialStatus,
    required this.isPaid,
  });

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  String status = "";
  late final Stream<DocumentSnapshot> orderStream;

  @override
  void initState() {
    super.initState();
    status = widget.initialStatus;
    orderStream = FirebaseFirestore.instance
        .collection('Orders')
        .doc(widget.orderNo)
        .snapshots();
  }

  /// Update status locally and in Firestore
  Future<void> _updateStatus(String newStatus) async {
    setState(() => status = newStatus);
    await FirebaseFirestore.instance
        .collection('Orders')
        .doc(widget.orderNo)
        .update({'Status': newStatus});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Track Order")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: orderStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final orderData = snapshot.data!.data() as Map<String, dynamic>? ?? {};
          final currentStatus = orderData['Status'] ?? status;
          final menus = List<String>.from(orderData['Menus'] ?? []);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Order No: ${widget.orderNo}",
                    style:
                        const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 16),
                Text("Payment: ${orderData['PaymentMethod'] ?? '-'}",
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                Text("Status: $currentStatus",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                const Text("Items:", style: TextStyle(fontWeight: FontWeight.bold)),
                ...menus.map((e) => ListTile(title: Text(e))),
                const SizedBox(height: 24),
                if (widget.isPaid == false && currentStatus == "Pending")
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => _updateStatus("Complete"),
                      child: const Text("Mark as Complete"),
                    ),
                  ),
                if (currentStatus == "Prepare")
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => _updateStatus("Ready for Pickup"),
                      child: const Text("Mark as Ready"),
                    ),
                  ),
                if (currentStatus == "Ready for Pickup")
                  const Text("Your order is ready for pickup!",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
          );
        },
      ),
    );
  }
}
