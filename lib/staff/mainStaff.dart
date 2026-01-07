import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'inventory.dart';
import 'staff.dart';
import 'Order.dart';

class mainstaff extends StatefulWidget {
  const mainstaff({super.key});

  @override
  State<mainstaff> createState() => _mainstaffState();
}

class _mainstaffState extends State<mainstaff> {
  int _currentIndex = 0;

  late final List<Widget> tabs;

  String? staffName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStaffName();
  }

  Future<void> _loadStaffName() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    setState(() {
      staffName = doc['name'];
      isLoading = false;

      tabs = [
        StaffPage(staffName: staffName!),
        OrderScreen(staffName: staffName!),
        Inventory(staffName: staffName!),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
