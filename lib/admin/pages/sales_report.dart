import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SalesReportPage extends StatefulWidget {
  const SalesReportPage({super.key});

  @override
  State<SalesReportPage> createState() => _SalesReportPageState();
}

class _SalesReportPageState extends State<SalesReportPage> {
  String selectedMonthly = 'January';
  String selectedYearly = '2025';
  String selectedRevenueYear = '2025';
  String selectedCashFlowYear = '2025';
  String selectedSalesMonth = 'January';
  String selectedSalesYear = '2025';

  final List<String> months = [
    'January','February','March','April','May','June',
    'July','August','September','October','November','December'
  ];

  final List<String> years = ['2021','2022','2023','2024','2025'];

  /// ================= SALES DATA =================

  List<double> monthlySalesData() =>
      List.generate(30, (i) => (i * 5 + 30).toDouble());

  List<double> yearlySalesData() =>
      List.generate(12, (i) => (i * 150 + 400).toDouble());

  /// ================= BAR CHARTS =================

  BarChartData _monthlyBarChart() {
    final data = monthlySalesData();

    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: 200,
      titlesData: _barTitles(
        bottom: (v) => v.toInt().toString(),
        interval: 5,
      ),
      barGroups: List.generate(data.length, (i) {
        return BarChartGroupData(
          x: i + 1,
          barRods: [
            BarChartRodData(
              toY: data[i],
              width: 6,
              borderRadius: BorderRadius.circular(4),
              color: Colors.blue,
            ),
          ],
        );
      }),
    );
  }

  BarChartData _yearlyBarChart() {
    final data = yearlySalesData();

    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: 2500,
      titlesData: _barTitles(
        bottom: (v) => months[v.toInt() - 1].substring(0, 3),
        interval: 1,
      ),
      barGroups: List.generate(12, (i) {
        return BarChartGroupData(
          x: i + 1,
          barRods: [
            BarChartRodData(
              toY: data[i],
              width: 14,
              borderRadius: BorderRadius.circular(6),
              color: Colors.blue,
            ),
          ],
        );
      }),
    );
  }

  FlTitlesData _barTitles({
    required String Function(double) bottom,
    required double interval,
  }) {
    return FlTitlesData(
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 300,
          getTitlesWidget: (v, _) =>
              Text("RM${v.toInt()}", style: const TextStyle(fontSize: 10)),
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: interval,
          getTitlesWidget: (v, _) =>
              Text(bottom(v), style: const TextStyle(fontSize: 10)),
        ),
      ),
    );
  }

  /// ================= CASH FLOW =================

  BarChartData _cashFlowChart() {
    final moneyIn = [800, 900, 750, 1000, 1200, 1100, 1300, 1250, 1150, 1400, 1500, 1600];
    final moneyOut = [500, 600, 550, 700, 800, 750, 900, 850, 780, 950, 1000, 1100];

    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: 1800,
      titlesData: FlTitlesData(
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 300,
            getTitlesWidget: (v, _) =>
                Text("RM${v.toInt()}", style: const TextStyle(fontSize: 10)),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (v, _) =>
                Text(months[v.toInt()].substring(0, 3),
                    style: const TextStyle(fontSize: 10)),
          ),
        ),
      ),
      barGroups: List.generate(12, (i) {
        return BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(toY: moneyIn[i].toDouble(), width: 8, color: Colors.green),
            BarChartRodData(toY: moneyOut[i].toDouble(), width: 8, color: Colors.red),
          ],
        );
      }),
    );
  }

  /// ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Admin Portal", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text("View sales and staff reports",
                style: TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          const Text("Sales Report",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 16),

          _sectionWithDropdown("Monthly Sales", selectedMonthly, months,
              (v) => setState(() => selectedMonthly = v)),
          _chartCard(BarChart(_monthlyBarChart())),

          const SizedBox(height: 20),

          _sectionWithDropdown("Yearly Sales", selectedYearly, years,
              (v) => setState(() => selectedYearly = v)),
          _chartCard(BarChart(_yearlyBarChart())),

          const SizedBox(height: 20),

          _sectionWithDropdown("Sales Revenue", selectedRevenueYear, years,
              (v) => setState(() => selectedRevenueYear = v)),
          const SalesRevenueList(),

          const SizedBox(height: 20),

          _sectionWithDropdown("Cash Flow", selectedCashFlowYear, years,
              (v) => setState(() => selectedCashFlowYear = v)),
          _chartCard(BarChart(_cashFlowChart())),

          const SizedBox(height: 20),

          const Text("Sales Person",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Row(
            children: [
              _compactDropdown(selectedSalesMonth, months,
                  (v) => setState(() => selectedSalesMonth = v)),
              const SizedBox(width: 8),
              _compactDropdown(selectedSalesYear, years,
                  (v) => setState(() => selectedSalesYear = v)),
            ],
          ),
          const SizedBox(height: 12),
          _salesPersonTable(),
        ]),
      ),
    );
  }

  /// ================= HELPERS =================

  Widget _sectionWithDropdown(String title, String selected,
      List<String> items, ValueChanged<String> onChanged) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          _compactDropdown(selected, items, onChanged),
        ],
      );

  Widget _compactDropdown(String selected, List<String> items,
      ValueChanged<String> onChanged) =>
      SizedBox(
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

  Widget _salesPersonTable() {
    final data = [
      {"name": "Nur Wanis Haris Binti Aiman", "units": 600},
      {"name": "Gopi Lui Yap (Part-Timer)", "units": 300},
      {"name": "Julian Anak Thomas", "units": 400},
      {"name": "Muhammad Bin Ali", "units": 500},
    ];

    int totalUnits =
        data.fold(0, (sum, d) => sum + (d["units"] as int));

    return Card(
      child: Column(
        children: [
          DataTable(
            columns: const [
              DataColumn(label: Text("Sales Person")),
              DataColumn(label: Text("Units Sold")),
            ],
            rows: data.map((d) => DataRow(cells: [
              DataCell(Text(d["name"].toString())),
              DataCell(Text(d["units"].toString())),
            ])).toList(),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text("Total Units Sold: $totalUnits",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= SALES REVENUE =================

class SalesRevenueList extends StatelessWidget {
  const SalesRevenueList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: const [
      RevenueCard("Today", "RM25.90", "Orders", "11"),
      RevenueCard("This Week", "RM97.30", "Orders", "39"),
      RevenueCard("This Month", "RM305.80", "Orders", "197"),
      RevenueCard("This Year", "RM1,594.30", "Orders", "1,005"),
    ]);
  }
}

class RevenueCard extends StatelessWidget {
  final String title, value, label, count;
  const RevenueCard(this.title, this.value, this.label, this.count, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title),
        subtitle: Text(value, style: const TextStyle(color: Colors.green)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label),
            Text(count, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
