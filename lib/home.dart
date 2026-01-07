import 'package:flutter/material.dart';
import 'package:kiosk_fcsit/menupage/menu.dart'; // <-- import the page you want to go to

class Home extends StatelessWidget {
  const Home({super.key});

  static const Color primaryBlue = Color(0xFF4F86D8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ===== APP BAR =====
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // classic back
          },
        ),
        actions: const [
          Icon(Icons.more_vert, color: Colors.black),
          SizedBox(width: 8),
        ],
      ),

      // ===== BODY =====
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            // ===== TITLE =====
            const Text(
              'Would you like to\nself-service or\nself-pickup?',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),

            const SizedBox(height: 40),

            // ===== SELF-SERVICE BUTTON =====
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Menu()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.restaurant, color: Colors.white),
                    SizedBox(width: 12),
                    Text(
                      'Self-service',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ===== SELF-PICKUP BUTTON =====
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Menu()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.shopping_bag, color: Colors.white),
                    SizedBox(width: 12),
                    Text(
                      'Self-pickup',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
