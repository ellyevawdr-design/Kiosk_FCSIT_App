import 'package:flutter/material.dart';
import 'mainStaff.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String selectedStaff = "Nuraqilah Binti Jolihi";

  final List<String> staffList = ["Nuraqilah Binti Jolihi", "Ahmad Bin Ali"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Staff Login",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            DropdownButtonFormField<String>(
              value: selectedStaff,
              items: staffList
                  .map(
                    (staff) =>
                        DropdownMenuItem(value: staff, child: Text(staff)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedStaff = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: "Select Staff",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => mainstaff(staffName: selectedStaff),
                    ),
                  );
                },
                child: const Text("Login"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
