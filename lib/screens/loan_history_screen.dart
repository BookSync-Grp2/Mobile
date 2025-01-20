import 'package:flutter/material.dart';
import 'package:mobile/services/loan_service.dart';
import 'package:mobile/widgets/loan_card.dart';

import '../models/loan.dart';
import '../services/service_locator.dart';

class LoanHistoryScreen extends StatefulWidget {
  const LoanHistoryScreen({super.key});

  @override
  State<LoanHistoryScreen> createState() => _LoanHistoryScreenState();
}

class _LoanHistoryScreenState extends State<LoanHistoryScreen> {
  LoanService loanService = getIt<LoanService>();
  List<Loan> currentLoans = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadLoans();
  }

  Future<void> loadLoans() async {
    setState(() => isLoading = true);
    final loans = await loanService.getPreviousLoans();
    setState(() {
      currentLoans = loans;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                                'Previous Loans',
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
    );
  }
}
