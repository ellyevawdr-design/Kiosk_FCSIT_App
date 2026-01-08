import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'new_order.dart';

class PaymentScreen extends StatefulWidget {
  final double total;
  const PaymentScreen({Key? key, required this.total}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _referenceController = TextEditingController();
  final _transactionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  bool _isScanning = false;

  // 📸 Pick image and run OCR
  Future<void> _scanPaymentReceipt() async {
    setState(() => _isScanning = true);

    final XFile? file = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
    );

    if (file == null) {
      setState(() => _isScanning = false);
      return;
    }

    await _runOCR(File(file.path));
    setState(() => _isScanning = false);
  }

  // 🔍 Run OCR and extract Reference ID
  Future<void> _runOCR(File image) async {
    final inputImage = InputImage.fromFile(image);
    final textRecognizer = TextRecognizer();
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    // Extract Reference ID
    String? refId = _extractReferenceId(recognizedText);

    setState(() {
      if (refId != null) {
        _referenceController.text = refId;
      } else {
        _referenceController.text = 'NOT FOUND';
      }

      // Auto-generate Transaction ID
      _transactionController.text =
          'TXN${Random().nextInt(999999999).toString().padLeft(9, '0')}';
    });

    textRecognizer.close();
  }

  // 🔑 Robust Reference ID extraction
  String? _extractReferenceId(RecognizedText recognizedText) {
    List<Map<String, dynamic>> lines = [];

    // Collect all lines with bounding boxes
    for (var block in recognizedText.blocks) {
      for (var line in block.lines) {
        lines.add({
          'text': line.text.trim(),
          'x': line.boundingBox.left,
          'y': line.boundingBox.top,
          'width': line.boundingBox.width,
        });
      }
    }

    if (lines.isEmpty) return null;

    // Approximate image width
    double minX = lines.map((l) => l['x'] as double).reduce((a, b) => a < b ? a : b);
    double maxX = lines
        .map((l) => (l['x'] as double) + (l['width'] as double))
        .reduce((a, b) => a > b ? a : b);

    double columnSplit = minX + (maxX - minX) * 0.4; // left 40% = label, right 60% = value

    List<Map<String, dynamic>> leftLines = [];
    List<Map<String, dynamic>> rightLines = [];

    for (var line in lines) {
      if ((line['x'] as double) < columnSplit) {
        leftLines.add(line);
      } else {
        rightLines.add(line);
      }
    }

    // Look for label in left column
    for (var left in leftLines) {
      final textLower = (left['text'] as String).toLowerCase();

      if (textLower.contains('reference') || textLower.contains('duitnow ref')) {
        // 1️⃣ Check same line for value (e.g., "Reference ID: QR87820257")
        final match = RegExp(r'([A-Z0-9]{6,})').firstMatch(left['text'] as String);
        if (match != null) return match.group(0);

        // 2️⃣ Otherwise, find nearest right column line vertically
        rightLines.sort((a, b) =>
            ((a['y'] as double) - (left['y'] as double)).abs().compareTo(
                ((b['y'] as double) - (left['y'] as double)).abs()));
        if (rightLines.isNotEmpty) return rightLines.first['text'] as String;
      }
    }

    return null;
  }

  @override
  void dispose() {
    _referenceController.dispose();
    _transactionController.dispose();
    super.dispose();
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
            // 💰 Total amount
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text('Total Amount',
                      style: TextStyle(color: Colors.grey[600])),
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

            // 📸 Scan button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isScanning ? null : _scanPaymentReceipt,
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

            // OR divider
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

            // ✍️ Manual inputs
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

            // ✅ Complete order
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _referenceController.text.isEmpty ||
                        _transactionController.text.isEmpty
                    ? null
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Order completed successfully!'),
                          ),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewOrderScreen(),
                          ),
                        );
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
