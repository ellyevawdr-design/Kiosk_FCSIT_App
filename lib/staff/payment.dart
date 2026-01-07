import 'package:flutter/material.dart';
import 'dart:math';

class PaymentScreen extends StatefulWidget {
  final double total;
  const PaymentScreen({Key? key, required this.total}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _referenceController = TextEditingController();
  final _transactionController = TextEditingController();
  bool _isScanning = false;

  void scanPayment() {
    setState(() => _isScanning = true);
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _referenceController.text =
            'REF${Random().nextInt(999999).toString().padLeft(6, '0')}';
        _transactionController.text =
            'TXN${Random().nextInt(999999999).toString().padLeft(9, '0')}';
        _isScanning = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'Total Amount',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'RM ${widget.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isScanning ? null : scanPayment,
                icon: Icon(
                  _isScanning ? Icons.hourglass_empty : Icons.qr_code_scanner,
                ),
                label: Text(
                  _isScanning ? 'Scanning...' : 'Scan Payment Receipt',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey[300])),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('OR', style: TextStyle(color: Colors.grey[600])),
                ),
                Expanded(child: Divider(color: Colors.grey[300])),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _referenceController,
              decoration: InputDecoration(
                labelText: 'Payment Reference Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _transactionController,
              decoration: InputDecoration(
                labelText: 'Transaction ID',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    _referenceController.text.isEmpty ||
                        _transactionController.text.isEmpty
                    ? null
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Order completed successfully!'),
                          ),
                        );
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Complete Order',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
