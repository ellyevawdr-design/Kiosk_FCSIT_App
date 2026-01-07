import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'package:kiosk_fcsit/admin/admin_main.dart';
import 'package:kiosk_fcsit/staff/mainStaff.dart';

class StaffLogin extends StatefulWidget {
  const StaffLogin({super.key});

  @override
  _StaffLoginState createState() => _StaffLoginState();
}

class _StaffLoginState extends State<StaffLogin> {
  final AuthService _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _rememberMe = false;

  void _login() async {
    setState(() => _isLoading = true);
    String? result = await _authService.login(
      email: _emailController.text,
      password: _passwordController.text,
    );
    setState(() => _isLoading = false);

    // Navigate based on role or show error message
    if (result == 'Admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const AdminHome(),
        ),
      );
    }  else if (result == 'Staff') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const mainstaff(),
        ),
      );
    }else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Login Failed: $result'), // Show error message
      ));
    }
  }

  bool isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The background gradient to match the screenshot
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF64B5F6), // Light blue
              Color(0xFF42A5F5), // Standard blue
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Back Button
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                // PERTEKMA Logo
                Image.asset("assets/logo/pertekma.png", height: 120),
                const SizedBox(height: 40),
                const Text(
                  "MOBILE SIGN IN",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 50),
                // Single ID Input
                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  decoration: const InputDecoration(
                    labelText: 'Single ID',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Password Input
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Remember Me & Forgot Password Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (val) => setState(() => _rememberMe = val!),
                          side: const BorderSide(color: Colors.white),
                          shape: const CircleBorder(),
                        ),
                        const Text("Remember me", style: TextStyle(color: Colors.black54, fontSize: 12)),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Forgot password?",
                        style: TextStyle(color: Color.fromARGB(255, 250, 250, 250), fontSize: 12, decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // Login button (Next)
                _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 52, 138, 237), // Muted Blue from image
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Next',
                            style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}