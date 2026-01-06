import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:networkclan_kiosk_fcsit_app/feature/auth/controller/auth_controller.dart';
import 'package:routemaster/routemaster.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final _nameController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    _nameController.text = user?.username ?? '';
  }

  Future<void> _updateProfile() async {
    final authController = ref.read(authControllerProvider.notifier);
    final username = _nameController.text.trim();
    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();

    if (username.isEmpty && newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a username or new password to update"),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      //Update username
      if (username.isNotEmpty) {
        await authController.updateUsername(context, username);
        _nameController.text = username; // live update
      }

      //Update password with re-authentication
      if (newPassword.isNotEmpty) {
        if (newPassword.length < 6) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("New password must be at least 6 characters"),
            ),
          );
        } else if (currentPassword.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Please enter your current password to change password",
              ),
            ),
          );
        } else {
          await authController.updatePassword(
            context,
            currentPassword,
            newPassword,
          );
        }
      }

      // Clear password fields
      _currentPasswordController.clear();
      _newPasswordController.clear();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Something went wrong: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final email =
        user?.email ??
        FirebaseAuth.instance.currentUser?.email ??
        'Unknown email';
    final username = user?.username ?? 'No Name';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Routemaster.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: AbsorbPointer(
          absorbing: _isLoading,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // PROFILE ICON + USERNAME
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: user?.profileImage != null
                            ? NetworkImage(user!.profileImage!)
                            : null,
                        child: user?.profileImage == null
                            ? const Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        username,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // EMAIL (read-only)
                const Text(
                  'Email',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: TextEditingController(text: email),
                  readOnly: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // EDIT NAME
                const Text(
                  'Edit Name',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter new name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // CURRENT PASSWORD (for re-authentication)
                const Text(
                  'Current Password',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _currentPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Enter current password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // NEW PASSWORD
                const Text(
                  'New Password',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Enter new password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),

                // SAVE CHANGES BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _updateProfile,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Save Changes'),
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
