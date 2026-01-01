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
  int selectedIndex = 0;

  // Lazy-initialized pages
  final Map<int, Widget> _pageCache = {};

  void _onItemTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget _getPage(int index) {
    // If already built, return cached version
    if (_pageCache.containsKey(index)) return _pageCache[index]!;

    // Build and cache the page
    late Widget page;
    switch (index) {
      case 0:
        page = const HomeScreen();
        break;
      case 1:
        page = const FavouriteScreen();
        break;
      case 2:
        page = const CartScreen();
        break;
      case 3:
        page = const SettingsScreen();
        break;
      default:
        page = const SizedBox.shrink();
    }

    _pageCache[index] = RepaintBoundary(child: page);
    return _pageCache[index]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: _getPage(selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColor.primaryColor,
        currentIndex: selectedIndex,
        selectedItemColor: Colors.lightBlue,
        unselectedItemColor: Colors.black,
        onTap: _onItemTap,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, size: 30),
            label: "Favourite",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket, size: 30),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, size: 30),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
