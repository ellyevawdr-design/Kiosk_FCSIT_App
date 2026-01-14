import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintReportService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> printSalesReport({
    required String month,
    required String year,
  }) async {
    final pdf = pw.Document();

    /// ================= FETCH DATA =================
    final vendorSnap = await _db.collection('Vendors').get();
    final ordersSnap = await _db.collection('Orders').get();

    double totalRevenue = 0;
    double totalCashOut = 0; // new
    int totalOrders = 0;

    final vendorRows = <List<String>>[];
    final weeklyRows = <List<String>>[];

    final monthIndex = _monthIndex(month);
    final yearInt = int.parse(year);

    // ----------------- Vendors -----------------
    for (var docu in vendorSnap.docs) {
      final data = docu.data();
      final date = DateTime.parse(data['Date']);

      if (date.year == yearInt && date.month == monthIndex) {
        final amount = (data['amount'] as num).toDouble();

        vendorRows.add([data['name'] ?? 'Unknown', amount.toStringAsFixed(2)]);
      }
    }

    // Calculate total cash out from Vendors collection
    for (var vendorDoc in vendorSnap.docs) {
      final data = vendorDoc.data();
      final date = DateTime.parse(data['Date']);
      if (date.year.toString() == year && date.month == _monthIndex(month)) {
        totalCashOut += (data['amount'] as num).toDouble();
      }
    }
    

    // ----------------- Orders per week -----------------
    // Map: week number -> {'orders': count, 'amount': sum}
    final Map<int, Map<String, double>> weekMap = {};

    for (var docu in ordersSnap.docs) {
      final data = docu.data();
      final date = DateTime.parse(data['Date']);

      if (date.year == yearInt && date.month == monthIndex) {
        final orderTotal = (data['Total'] as num).toDouble();
        totalRevenue += orderTotal;
        totalOrders++;

        // Calculate week number (1-5)
        final weekNumber = ((date.day - 1) ~/ 7) + 1;

        if (!weekMap.containsKey(weekNumber)) {
          weekMap[weekNumber] = {'orders': 0, 'amount': 0};
        }

        weekMap[weekNumber]!['orders'] = weekMap[weekNumber]!['orders']! + 1;
        weekMap[weekNumber]!['amount'] =
            weekMap[weekNumber]!['amount']! + orderTotal;
      }
    }

    // Build weeklyRows
    for (int i = 1; i <= 5; i++) {
      if (weekMap.containsKey(i)) {
        final data = weekMap[i]!;
        weeklyRows.add([
          "Week $i",
          data['orders']!.toInt().toString(),
          data['amount']!.toStringAsFixed(2),
        ]);
      }
    }

    final netRevenue = totalRevenue - totalCashOut;

    /// ================= PDF CONTENT =================
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (_) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              "Sales Report",
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 6),
            pw.Text("Period: $month $year"),
            pw.Divider(),

            /// Vendors Table
            pw.Text("Vendor", style: pw.TextStyle(fontSize: 14)),
            pw.SizedBox(height: 6),
            pw.Table.fromTextArray(
              headers: ["Name", "Amount (RM)"],
              data: vendorRows,
            ),

            pw.SizedBox(height: 12),

            /// Orders Table
            pw.Text("Orders (by Week)", style: pw.TextStyle(fontSize: 14)),
            pw.SizedBox(height: 6),
            pw.Table.fromTextArray(
              headers: ["Week", "Total Orders", "Amount (RM)"],
              data: weeklyRows,
            ),

            pw.SizedBox(height: 12),
            pw.Divider(),

            /// Summary
            pw.Text(
              "Summary",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text("Total Orders: $totalOrders"),
            pw.Text("Total Revenue: RM ${totalRevenue.toStringAsFixed(2)}"),
            pw.Text("Total Cash Out: RM ${totalCashOut.toStringAsFixed(2)}"),
            pw.Text("Net Revenue: RM ${netRevenue.toStringAsFixed(2)}"),
          ],
        ),
      ),
    );

    /// ================= PRINT/EXPORT =================
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  int _monthIndex(String m) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months.indexOf(m) + 1;
  }
}
