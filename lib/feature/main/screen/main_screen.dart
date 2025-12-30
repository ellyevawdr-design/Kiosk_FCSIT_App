import 'package:flutter/material.dart';
import 'package:networkclan_kiosk_fcsit_app/feature/cart/screen/cart_screen.dart';
import 'package:networkclan_kiosk_fcsit_app/feature/favourites/screen/favourite_screen.dart';
import 'package:networkclan_kiosk_fcsit_app/feature/home/screen/home_screen.dart';
import 'package:networkclan_kiosk_fcsit_app/feature/settings/screen/settings_screen.dart';
import 'package:networkclan_kiosk_fcsit_app/utils/color.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0; // corrected variable name

  void _onItemTap(int index) {
    setState(() {
      selectedIndex = index; // corrected here
    });
  }

  List<Widget> pages = [
    HomeScreen(),
    FavouriteScreen(),
    CartScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColor.primaryColor,
        currentIndex: selectedIndex, // corrected here
        selectedItemColor: Colors.lightBlue,
        onTap: _onItemTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black, size: 30),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: Colors.black, size: 30),
            label: "Favourite",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket, color: Colors.black, size: 30),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Colors.black, size: 30),
            label: "Settings",
          ),
        ],
      ),
      body: pages[selectedIndex], // corrected here
    );
  }
}
