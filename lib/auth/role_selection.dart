import 'package:flutter/material.dart';
import 'package:kiosk_fcsit/auth/staff_login.dart';
import 'package:kiosk_fcsit/auth/user_login.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF42A5F5), // Lighter blue at the top
              Color(0xFF1976D2), // Standard blue in the middle
              Color(0xFF0D47A1), // Deep navy blue at the bottom
            ],
          ), 
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              // PERTEKMA Logo Placeholder
              // Replace 'assets/logo.png' with your actual path
              Image.asset(
                'assets/logo/pertekma.png', 
                height: 120,
              ),
              const SizedBox(height: 20),
              // Title Text
              const Text(
                "KIOSK | FCSIT",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                  fontFamily: 'Serif', // Using a serif style for the header
                ),
              ),
              const Spacer(),
              // Main Illustration Placeholder
              // Replace 'assets/kiosk_illustration.png' with your actual path
              Image.asset(
                'assets/logo/kiosk.png',
                height: 300,
              ),
              const Spacer(),
              // Customer Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: SizedBox(
                  width: 220,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A237E), // Deep Blue
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      "Customer",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Admin/Staff Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: SizedBox(
                  width: 220,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF26C6DA), // Cyan/Teal
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const StaffLogin()),
                      );
                    },
                    child: const Text(
                      "Admin/Staff",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}