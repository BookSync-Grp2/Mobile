import 'package:flutter/material.dart';
import 'package:mobile/middleware/auth_guard.dart';
import 'package:mobile/screens/create_loan_screen.dart';
import 'package:mobile/screens/home_screen.dart';
import 'package:mobile/screens/login_screen.dart';
import 'package:mobile/screens/register_screen.dart';
import 'package:mobile/services/service_locator.dart';
import 'package:mobile/widgets/route_transitions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BookSync',
      home: AuthGuard(
        child: HomeScreen(),
      ),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/home':
            return NoTransitionPageRoute(
              page: const HomeScreen(),
              settings: const RouteSettings(name: "/home"),
            );
          case '/register':
            return NoTransitionPageRoute(
              page: const RegisterScreen(),
              settings: const RouteSettings(name: "/register"),
            );
          case '/login':
            return NoTransitionPageRoute(
              page: const LoginScreen(),
              settings: const RouteSettings(name: "/login"),
            );
          case '/create-loan':
            return NoTransitionPageRoute(
              page: const CreateLoanScreen(),
              settings: const RouteSettings(name: "/create-loan"),
            );
        }
        return null;
      },
    );
  }
}
