import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile/models/loan.dart';
import 'package:mobile/services/auth_service.dart';
import 'package:mobile/utils/constants.dart';

import '../models/book.dart';

class LoanService {
  final AuthService _authService;
  static int currentBooksCount = 0;

  LoanService(this._authService);

  Future<List<Loan>> getCurrentLoans() async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/api/loans/current'),
        headers: _authService.authHeaders,
      );

      if (response.statusCode == 200) {
        final List<dynamic> loansJson = jsonDecode(response.body);
        final loans = loansJson.map((json) => Loan.fromJson(json)).toList();

        if (loans.isEmpty) return [];

        await Future.wait(
          loans.map((loan) async {
            final book = await _fetchBookDetails(loan.bookId);
            loan.book = book;
          }),
        );

        currentBooksCount = loans.length;
        return loans;
      } else {
        throw Exception('Failed to load loans');
      }
    } catch (e) {
      print('Error fetching loans: $e');
      return [];
    }
  }

  Future<List<Loan>> getPreviousLoans() async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/api/loans/previous'),
        headers: _authService.authHeaders,
      );

      if (response.statusCode == 200) {
        final List<dynamic> loansJson = jsonDecode(response.body);
        final loans = loansJson.map((json) => Loan.fromJson(json)).toList();

        if (loans.isEmpty) return [];

        await Future.wait(
          loans.map((loan) async {
            final book = await _fetchBookDetails(loan.bookId);
            loan.book = book;
          }),
        );

        return loans;
      } else {
        throw Exception('Failed to load loans');
      }
    } catch (e) {
      print('Error fetching loans: $e');
      return [];
    }
  }

  Future<Book?> _fetchBookDetails(int bookId) async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/api/books/$bookId'),
        headers: _authService.authHeaders,
      );

      if (response.statusCode == 200) {
        final bookJson = jsonDecode(response.body);
        return Book.fromJson(bookJson);
      }
    } catch (e) {
      print('Error fetching book details: $e');
    }
    return null;
  }
}
