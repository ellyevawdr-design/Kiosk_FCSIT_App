import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'admin_staff.dart';
import 'sales_report.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin Portal',
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(88, 100, 235, 1), // admin blue
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(88, 100, 235, 1),
          foregroundColor: Colors.white,
        ),
      ),
      home: const AdminHome(),
    );
  }
}

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    SalesReportPage(),
    AdminStaffPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color.fromRGBO(88, 100, 235, 1), // blue icon
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white, // white background
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Report",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "Staff",
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
