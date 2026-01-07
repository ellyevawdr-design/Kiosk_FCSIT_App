import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  bool _loading = false;

  User? get user => FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  /// Load name from Firestore
  Future<void> _loadUserData() async {
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    if (doc.exists) {
      _nameController.text = doc['name'] ?? '';
    }
  }

  /// Update name + password
  Future<void> _saveProfile() async {
    if (user == null) return;

    setState(() => _loading = true);

    try {
      // ===== UPDATE NAME =====
      if (_nameController.text.trim().isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({
          'name': _nameController.text.trim(),
        });
      }

      // ===== UPDATE PASSWORD =====
      if (_newPasswordController.text.isNotEmpty) {
        if (_newPasswordController.text.length < 6) {
          _showMsg('Password must be at least 6 characters');
          return;
        }

        if (_currentPasswordController.text.isEmpty) {
          _showMsg('Enter current password');
          return;
        }

        // Re-authenticate
        final credential = EmailAuthProvider.credential(
          email: user!.email!,
          password: _currentPasswordController.text,
        );

        await user!.reauthenticateWithCredential(credential);
        await user!.updatePassword(_newPasswordController.text);

        _currentPasswordController.clear();
        _newPasswordController.clear();
      }

      _showMsg('Profile updated successfully');
    } catch (e) {
      _showMsg(e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
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
    final email = user?.email ?? 'Unknown';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ===== HEADER =====
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xFF6C63FF),
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _nameController.text.isEmpty
                        ? 'No Name'
                        : _nameController.text,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    email,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ===== EDIT NAME =====
            _card(
              title: 'Edit Name',
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Enter new name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            // ===== CHANGE PASSWORD =====
            _card(
              title: 'Change Password',
              child: Column(
                children: [
                  TextField(
                    controller: _currentPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Current password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _newPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'New password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ===== SAVE BUTTON =====
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _loading ? null : _saveProfile,
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Reusable card
  Widget _card({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
