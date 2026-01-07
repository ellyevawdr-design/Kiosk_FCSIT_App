import 'package:flutter/material.dart';
import 'user_login.dart';
import 'auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthService _authService = AuthService();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedRole = 'User';
  bool _isLoading = false;
  bool isPasswordHidden = true;

  void _signup() async {
    setState(() {
      _isLoading = true;
    });

    String? result = await _authService.signup(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      role: _selectedRole,
    );

    setState(() {
      _isLoading = false;
    });

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Signup Successful! Now Turn to Login'),
      ));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Signup Failed: $result'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Gradient background to match the login page
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6AB7FF),
              Color(0xFF42A5F5),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Back Button
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.black45, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                // Logo
                Center(
                  child: Image.asset("assets/logo/pertekma.png", height: 140),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    "CREATE ACCOUNT",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Name Field
                TextField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Email Field
                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Password Field
                TextField(
                  controller: _passwordController,
                  obscureText: isPasswordHidden,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Colors.white, fontSize: 16),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white70,
                      ),
                      onPressed: () => setState(() => isPasswordHidden = !isPasswordHidden),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Role Selection (Styled Dropdown)
                Theme(
                  data: Theme.of(context).copyWith(canvasColor: Colors.blue[400]),
                  child: DropdownButtonFormField<String>(
                    value: _selectedRole,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    decoration: const InputDecoration(
                      labelText: 'Role',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRole = newValue!;
                      });
                    },
                    items: ['User'].map((role) {
                      return DropdownMenuItem(
                        value: role,
                        child: Text(role, style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 40),
                // Signup Button
                _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.white))
                    : SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: _signup,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 52, 138, 237),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Signup',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                const SizedBox(height: 20),
                // Back to Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.black45, fontSize: 14),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                        );
                      },
                      child: const Text(
                        "Login here",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}