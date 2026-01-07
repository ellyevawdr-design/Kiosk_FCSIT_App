import 'package:flutter/material.dart';
import 'new_order.dart';
import 'staff_header.dart';

class OrderScreen extends StatefulWidget {
  final String staffName;
  const OrderScreen({super.key, required this.staffName});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> orders = [
    {
      'id': '1001',
      'time': '10:30 AM',
      'payment': 'Cash',
      'status': 'Pending',
      'type': 'Delivery',
      'total': 4.50,
      'itemsList': [
        {'name': 'Nasi Lemak', 'quantity': 1},
        {'name': 'Mineral Water', 'quantity': 1},
      ],
    },
    {
      'id': '1002',
      'time': '10:45 AM',
      'payment': 'QR',
      'status': 'Approved',
      'type': 'Pickup',
      'total': 12.00,
      'itemsList': [
        {'name': 'Mee Goreng', 'quantity': 2},
        {'name': 'Coffee', 'quantity': 2},
      ],
    },
    {
      'id': '1003',
      'time': '11:00 AM',
      'payment': 'Cash',
      'status': 'Ready for Pickup',
      'type': 'Pickup',
      'total': 7.50,
      'itemsList': [
        {'name': 'Roti Canai', 'quantity': 1},
        {'name': 'Teh Tarik', 'quantity': 1},
      ],
    },
    {
      'id': '1004',
      'time': '11:15 AM',
      'payment': 'QR',
      'status': 'Completed',
      'type': 'Delivery',
      'total': 5.00,
      'itemsList': [
        {'name': 'Burger', 'quantity': 1},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  // ===== FILTER ORDERS =====
  List<Map<String, dynamic>> getAwaitingOrders() {
    return orders.where((order) =>
        (order['status'] == 'Pending' ||
            (order['status'] == 'Ready for Pickup' && order['type'] == 'Pickup')) &&
        (order['payment'] == 'Cash' || order['payment'] == 'QR')).toList();
  }

  List<Map<String, dynamic>> getPickupOrders() {
    return orders
        .where((order) => order['status'] == 'Approved' && order['type'] == 'Pickup')
        .toList();
  }

  List<Map<String, dynamic>> getHistoryOrders() {
    return orders.where((order) => order['status'] == 'Completed').toList();
  }

  // ===== STATUS ACTIONS =====
  void approveOrder(Map<String, dynamic> order) {
    setState(() {
      if (order['type'] == 'Pickup') {
        order['status'] = 'Approved';
      } else {
        order['status'] = 'Completed';
      }
    });
  }

  void readyToPickup(Map<String, dynamic> order) {
    setState(() {
      order['status'] = 'Ready for Pickup';
    });
  }

  void markCompleted(Map<String, dynamic> order) {
    setState(() {
      order['status'] = 'Completed';
    });
  }

  // ===== BUILD ORDER CARD =====
  Widget buildOrderCard(Map<String, dynamic> order, {bool isPickupTab = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== HEADER =====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ord #${order['id']}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('${order['time']} , ${order['payment']}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
            const SizedBox(height: 8),
            // ===== ITEMS LIST =====
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List<Widget>.from(
                (order['itemsList'] ?? []).map<Widget>((item) => Text(
                      '${item['name']} x${item['quantity']}',
                      style: const TextStyle(fontSize: 14),
                    )),
              ),
            ),
            const SizedBox(height: 8),
            // ===== TOTAL + BUTTON =====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('RM ${order['total'].toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                if (order['status'] == 'Pending')
                  ElevatedButton(
                    onPressed: () => approveOrder(order),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Approve Order'),
                  )
                else if (isPickupTab && order['status'] == 'Approved')
                  ElevatedButton(
                    onPressed: () => readyToPickup(order),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Ready to Pickup'),
                  )
                else if (order['status'] == 'Ready for Pickup')
                  ElevatedButton(
                    onPressed: () => markCompleted(order),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Mark as Completed'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ===== HEADER + NEW ORDER BUTTON =====
        StaffHeader(staffName: widget.staffName),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Orders',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NewOrderScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('New Order'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B47FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
          // ===== TABS =====
          TabBar(
            controller: _tabController,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: const [
              Tab(text: 'Awaiting'),
              Tab(text: 'Pickup'),
              Tab(text: 'History'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: getAwaitingOrders()
                        .map((order) => buildOrderCard(order))
                        .toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: getPickupOrders()
                        .map((order) => buildOrderCard(order, isPickupTab: true))
                        .toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: getHistoryOrders()
                        .map((order) => buildOrderCard(order))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
