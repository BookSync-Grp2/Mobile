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
      body: Text("HELLO"),
      backgroundColor: Colors.white,
    );
  }
}
