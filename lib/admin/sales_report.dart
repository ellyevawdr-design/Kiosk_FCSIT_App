import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:kiosk_fcsit/admin/printReport.dart';

class SalesReportPage extends StatefulWidget {
  const SalesReportPage({super.key});

  @override
  State<SalesReportPage> createState() => _SalesReportPageState();
}

class RevenueCard extends StatelessWidget {
  final String title;
  final double amount;
  final int orders;

  const RevenueCard(this.title, this.amount, this.orders, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title),
        subtitle: Text(
          "RM ${amount.toStringAsFixed(2)}",
          style: const TextStyle(color: Colors.green),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Orders"),
            Text(
              orders.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _SalesReportPageState extends State<SalesReportPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String selectedMonthly = 'January';
  String selectedYearly = '2026';
  String selectedSalesMonth = 'January';
  String selectedSalesYear = '2026';

  final List<String> months = const [
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

  final List<String> years = const ['2024', '2025', '2026'];

  /// ================= FIRESTORE =================
  Future<List<QueryDocumentSnapshot>> _getOrders() async {
    final snap = await _db.collection('Orders').get();
    return snap.docs;
  }

  /// Get only users with role "User"
  Future<int> _getUserCount() async {
    try {
      final snap = await _db
          .collection('users')
          .where('role', isEqualTo: 'User') // filter by role
          .get();
      print("Users fetched: ${snap.docs.length}");
      for (var doc in snap.docs) {
        print(doc.data()); // debug print
      }
      return snap.docs.length;
    } catch (e) {
      print("Error fetching user count: $e");
      return 0;
    }
  }

  /// ================= DATA PROCESSING =================
  List<double> _monthlySales(List<QueryDocumentSnapshot> orders) {
    final year = int.parse(selectedYearly);
    final monthIndex = months.indexOf(selectedMonthly) + 1;
    final daysInMonth = DateTime(year, monthIndex + 1, 0).day;

    List<double> data = List.generate(daysInMonth, (_) => 0.0);

    for (var o in orders) {
      final date = DateTime.parse(o['Date']);
      if (date.year == year && date.month == monthIndex) {
        data[date.day - 1] += (o['Total'] as num).toDouble();
      }
    }
    return data;
  }

  List<double> _yearlySales(List<QueryDocumentSnapshot> orders) {
    List<double> data = List.generate(12, (_) => 0.0);

    for (var o in orders) {
      final date = DateTime.parse(o['Date']);
      if (date.year.toString() == selectedYearly) {
        data[date.month - 1] += (o['Total'] as num).toDouble();
      }
    }
    return data;
  }

  double _revenueBetween(
    List<QueryDocumentSnapshot> orders,
    DateTime start,
    DateTime end,
  ) {
    return orders.fold(0.0, (sum, o) {
      final date = DateTime.parse(o['Date']);
      if (!date.isBefore(start) && date.isBefore(end)) {
        return sum + (o['Total'] as num).toDouble();
      }
      return sum;
    });
  }

  int _ordersBetween(
    List<QueryDocumentSnapshot> orders,
    DateTime start,
    DateTime end,
  ) {
    return orders.where((o) {
      final date = DateTime.parse(o['Date']);
      return !date.isBefore(start) && date.isBefore(end);
    }).length;
  }

  /// ================= CHARTS =================
  double _safeInterval(double max) {
    if (max <= 0) return 1;
    final interval = (max / 5).ceilToDouble();
    return interval <= 0 ? 1 : interval;
  }

  BarChartData _barChart(List<double> data, String Function(double) bottom) {
    final maxY = data.isEmpty ? 10.0 : data.reduce((a, b) => a > b ? a : b);
    final interval = _safeInterval(maxY);

    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: maxY == 0 ? 10 : maxY,
      titlesData: FlTitlesData(
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: interval,
            reservedSize: 40,
            getTitlesWidget: (v, _) =>
                Text("RM${v.toInt()}", style: const TextStyle(fontSize: 10)),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (v, _) =>
                Text(bottom(v), style: const TextStyle(fontSize: 10)),
          ),
        ),
      ),
      barGroups: List.generate(data.length, (i) {
        return BarChartGroupData(
          x: i + 1,
          barRods: [
            BarChartRodData(
              toY: data[i].toDouble(),
              width: 6,
              borderRadius: BorderRadius.circular(4),
              color: Colors.blue,
            ),
          ],
        );
      }),
    );
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sales Report")),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: _getOrders(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final orders = snapshot.data!;
          final monthly = _monthlySales(orders);
          final yearly = _yearlySales(orders);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Monthly Sales
                _section(
                  "Monthly Sales",
                  selectedMonthly,
                  months,
                  (v) => setState(() => selectedMonthly = v),
                ),
                _chartCard(
                  BarChart(_barChart(monthly, (v) => v.toInt().toString())),
                ),

                const SizedBox(height: 20),

                // Yearly Sales
                _section(
                  "Yearly Sales",
                  selectedYearly,
                  years,
                  (v) => setState(() => selectedYearly = v),
                ),
                _chartCard(
                  BarChart(
                    _barChart(
                      yearly,
                      (v) => months[v.toInt() - 1].substring(0, 3),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Sales Revenue
                const Text(
                  "Sales Revenue",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Builder(
                  builder: (_) {
                    final now = DateTime.now();
                    final startToday = DateTime(now.year, now.month, now.day);
                    final startWeek = startToday.subtract(
                      Duration(days: startToday.weekday - 1),
                    );
                    final startMonth = DateTime(now.year, now.month, 1);
                    final startYear = DateTime(now.year, 1, 1);
                    final end = now.add(const Duration(days: 1));

                    return Column(
                      children: [
                        RevenueCard(
                          "Today",
                          _revenueBetween(orders, startToday, end),
                          _ordersBetween(orders, startToday, end),
                        ),
                        RevenueCard(
                          "This Week",
                          _revenueBetween(orders, startWeek, end),
                          _ordersBetween(orders, startWeek, end),
                        ),
                        RevenueCard(
                          "This Month",
                          _revenueBetween(orders, startMonth, end),
                          _ordersBetween(orders, startMonth, end),
                        ),
                        RevenueCard(
                          "This Year",
                          _revenueBetween(orders, startYear, end),
                          _ordersBetween(orders, startYear, end),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 16),

                /// Print Report Button
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () async {
                      final printer = PrintReportService();
                      await printer.printSalesReport(
                        month: selectedMonthly,
                        year: selectedYearly,
                      );
                    },
                    child: const Text("Print PDF"),
                  ),
                ),

                const SizedBox(height: 20),

                // Number of Users
                const Text(
                  "Number of Users",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                FutureBuilder<int>(
                  future: _getUserCount(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Card(
                        child: ListTile(
                          title: const Text("Registered Users"),
                          trailing: Text(
                            "Error",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      );
                    }

                    if (!snapshot.hasData) {
                      return Card(
                        child: ListTile(
                          title: const Text("Registered Users"),
                          trailing: Text(
                            "0",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }

                    // Show actual user count
                    return Card(
                      child: ListTile(
                        title: const Text("Registered Users"),
                        trailing: Text(
                          snapshot.data.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// ================= HELPERS =================
  Widget _section(
    String title,
    String selected,
    List<String> items,
    ValueChanged<String> onChanged,
  ) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      _dropdown(selected, items, onChanged),
    ],
  );

  Widget _dropdown(
    String selected,
    List<String> items,
    ValueChanged<String> onChanged,
  ) => SizedBox(
    width: 120,
    child: DropdownButton<String>(
      value: selected,
      isExpanded: true,
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (v) => onChanged(v!),
    ),
  );

  Widget _chartCard(Widget child) => Card(
    child: SizedBox(
      height: 280,
      width: double.infinity,
      child: Padding(padding: const EdgeInsets.all(12), child: child),
    ),
  );
}
