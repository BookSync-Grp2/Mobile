import 'package:flutter/material.dart';
import 'package:mobile/screens/login_screen.dart';
import 'package:mobile/services/auth_service.dart';
import 'package:mobile/services/service_locator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final authService = getIt<AuthService>();

    if (authService.currentUser == null) {
      return const LoginScreen();
    }

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 50),
          Center(
            child: Text(
              'Welcome, ${authService.currentUser!.firstName}!',
              style: const TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await authService.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Logout'),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
