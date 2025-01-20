import 'package:flutter/material.dart';
import 'package:mobile/models/loan.dart';
import 'package:mobile/services/auth_service.dart';
import 'package:mobile/services/loan_service.dart';
import 'package:mobile/services/service_locator.dart';

import '../widgets/loan_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final authService = getIt<AuthService>();
  final loanService = getIt<LoanService>();
  List<Loan> currentLoans = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadLoans();
  }

  Future<void> loadLoans() async {
    setState(() => isLoading = true);
    final loans = await loanService.getCurrentLoans();
    setState(() {
      currentLoans = loans;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/profile');
          },
          child: Text('Welcome, ${authService.currentUser!.firstName}!'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Loan History',
            onPressed: () => Navigator.pushNamed(context, '/loan-history'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: loadLoans,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index == 0) {
                            return const Padding(
                              padding: EdgeInsets.only(bottom: 16.0),
                              child: Text(
                                'Current Loans',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }
                          final loan = currentLoans[index - 1];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: LoanCard(loan: loan),
                          );
                        },
                        childCount:
                            currentLoans.isEmpty ? 1 : currentLoans.length + 1,
                      ),
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/create-loan');
        },
        label: const Text('New Loan'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
