import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  static const Color primary = Color(0xFF2B6CB0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(43, 108, 176, 1),
        title: const Text("Home"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to FCSIT Kiosk",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/menu'),
              child: const Text("View Menu"),
            ),
          ],
        ),
      ),
    );
  }
}
