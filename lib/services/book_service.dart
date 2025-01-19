import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile/models/book.dart';
import 'package:mobile/services/auth_service.dart';
import 'package:mobile/utils/constants.dart';

class BookService {
  final AuthService _authService;

  BookService(this._authService);

  Future<List<Book>> searchBooks(String query) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${Constants.baseUrl}/api/books/search?query=$query&available=true'),
        headers: _authService.authHeaders,
      );

      if (response.statusCode == 200) {
        final List<dynamic> booksJson = jsonDecode(response.body);
        return booksJson.map((json) => Book.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search books');
      }
    } catch (e) {
      print('Error searching books: $e');
      return [];
    }
  }

  Future<bool> createLoan(int bookId) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/loans/create'),
        headers: {
          ..._authService.authHeaders,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'bookId': bookId,
          'userId': _authService.currentUser!.id,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error creating loan: $e');
      return false;
    }
  }
}
