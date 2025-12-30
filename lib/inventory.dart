import 'package:flutter/material.dart';

class inventory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ===== BLUE HEADER =====
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(20, 60, 20, 30),
          color: Color(0xFF3B47FF),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Staff Portal",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "Manage your kiosk inventory & orders",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
