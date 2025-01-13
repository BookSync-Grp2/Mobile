import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class AuthService {
  User? _currentUser;
  final _storage = const FlutterSecureStorage();

  User? get currentUser => _currentUser;

  // Check if user is logged in on app start
  Future<bool> init() async {
    final token = await _storage.read(key: 'token');
    if (token == null) return false;

    try {
      // Validate token with backend and get user info
      final response = await http.get(
        //TODO ADD .ENV VARIABLES
        Uri.parse('http://localhost:5000/api/user/me'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        _currentUser = User.fromJson(userData, token);
        return true;
      }
    } catch (e) {
      await logout();
    }
    return false;
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        //TODO ADD .ENV VARIABLES
        Uri.parse('http://localhost:5000/api/auth/login'),
        body: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];

        // Store token
        await _storage.write(key: 'token', value: token);

        // Get user info
        _currentUser = User.fromJson(data['user'], token);
        return true;
      }
    } catch (e) {
      // Handle error
    }
    return false;
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
    _currentUser = null;
  }

  Future<bool> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/api/auth/register'),
        body: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 201) {
        // TODO Add automatic login here
        return true;
      }
    } catch (e) {
      // TODO Handle error
    }
    return false;
  }

  Map<String, String> get authHeaders =>
      {'Authorization': 'Bearer ${_currentUser?.token ?? ''}'};
}
