import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class CustomerPage extends StatelessWidget {
  const CustomerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ===== TOP IMAGE SECTION =====
            SizedBox(
              height: screenHeight * 0.45,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  // Blue background shape
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 220,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1E88E5),
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(160),
                        ),
                      ),
                    ),
                  ),

                  // Drink (left)
                  Positioned(
                    left: 32,
                    top: 60,
                    child: Image.asset(
                      'assets/images/cola.png',
                      height: 140,
                      fit: BoxFit.contain,
                    ),
                  ),

                  // Cake (right)
                  Positioned(
                    right: 32,
                    top: 70,
                    child: Image.asset(
                      'assets/images/choc_cake.png',
                      height: 130,
                      fit: BoxFit.contain,
                    ),
                  ),

                  // Bowl (center front)
                  Positioned(
                    bottom: -10,
                    child: Image.asset(
                      'assets/images/bubur.png',
                      height: 110,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ===== TEXT SECTION =====
            const Text(
              'Tap To Order',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Order your favorite meal\nfor self-service or self-pickup',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
            ),

            const Spacer(),

            // ===== BUTTON =====
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: SizedBox(
                width: 180,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90E2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () {
                    //Navigate to home
                    Routemaster.of(context).push('/home');
                  },
                  child: const Text(
                    'Tap To Order',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
