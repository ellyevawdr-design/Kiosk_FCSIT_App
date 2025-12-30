import 'package:flutter/material.dart';
import 'inventory.dart';
import 'staff.dart';
import 'Order.dart';

class mainstaff extends StatefulWidget {
  final String staffName;

  const mainstaff({super.key, required this.staffName});

  @override
  State<mainstaff> createState() => _mainstaffState();
}

class _mainstaffState extends State<mainstaff> {
  int _currentIndex = 0;

  late final List<Widget> tabs;

  @override
  void initState() {
    super.initState();
    tabs = [
      StaffPage(staffName: widget.staffName),
      Order(staffName: widget.staffName),
      inventory(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            label: "Staff",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: "Order",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: "Inventory",
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
