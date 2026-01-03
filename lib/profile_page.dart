import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Routemaster.of(context).pop(),
        ),
      ),
      body: const Center(
        child: Text('Profile Page', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
