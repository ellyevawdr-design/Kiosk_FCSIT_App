import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:networkclan_kiosk_fcsit_app/feature/auth/controller/auth_controller.dart';
import 'package:networkclan_kiosk_fcsit_app/feature/auth/screen/log_in_screen.dart';
import 'package:networkclan_kiosk_fcsit_app/utils/color.dart';
import 'package:networkclan_kiosk_fcsit_app/utils/widgets/custome_text_field.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _username.dispose();
    super.dispose();
  }

  Future<void> _signUp(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    await ref
        .read(authControllerProvider.notifier)
        .signUpWithEmailAndPassword(
          _email.text.trim(),
          _password.text.trim(),
          _username.text.trim(),
          context,
        );

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(elevation: 0, backgroundColor: AppColor.primaryColor),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  Center(
                    child: Image.asset(
                      "assets/logo/unimas.png",
                      height: 143,
                      width: 143,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Welcome Back",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Get the best food, on the comfort of your pack scheduling",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(height: 32),
                  CustomTextField(
                    controller: _email,
                    hintText: "Enter your email",
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Email cannot be empty';
                      if (!value.contains('@')) return 'Enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _username,
                    hintText: "Enter username",
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Username cannot be empty';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _password,
                    hintText: "Enter your password",
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Password cannot be empty';
                      if (value.length < 6)
                        return 'Password must be at least 6 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () => _signUp(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Register",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: _isLoading
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LogInScreen(),
                              ),
                            );
                          },
                    child: RichText(
                      text: TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400,
                        ),
                        children: const [
                          TextSpan(
                            text: "Sign In",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.lightBlue,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
