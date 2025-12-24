import 'package:flutter/material.dart';

class OrderType extends StatelessWidget {
  const OrderType({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Bar
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    const Icon(Icons.more_vert),
                  ],
                ),

                const SizedBox(height: 40),

                // Title
                const Text(
                  "Would you like to\nself-service or\nself-pickup?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 60),

                // Self-service Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90E2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/order');
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.restaurant, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        "Self-service",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Self-pickup Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90E2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/menu');
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_bag, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        "Self-pickup",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
