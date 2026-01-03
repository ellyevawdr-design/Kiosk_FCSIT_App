import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Main Screen'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _mainButton(context, title: 'Order Type', route: '/order-type'),
            const SizedBox(height: 16),
            _mainButton(context, title: 'Menu', route: '/menu'),
            const SizedBox(height: 16),
            _mainButton(context, title: 'Home Page', route: '/home'),
          ],
        ),
      ),
    );
  }

  Widget _mainButton(
    BuildContext context, {
    required String title,
    required String route,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          Routemaster.of(context).push(route);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
