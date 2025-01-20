import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/utils/constants.dart';

import '../models/user.dart';

class AuthService {
  User? _currentUser;
  final _storage = const FlutterSecureStorage();

  User? get currentUser => _currentUser;
  String get baseUrl => Constants.baseUrl;

  Future<bool> init() async {
    final token = await _storage.read(key: 'token');
    if (token == null || !isTokenValid(token)) {
      await logout();
      return false;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/user/me'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _currentUser = User.fromJson(data, token);

        return true;
      } else {
        await logout();
        return false;
      }
    } catch (e) {
      await logout();
    }
    return false;
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await http
          .post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      )
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Login request timed out');
        },
      );

      if (response.statusCode == 200) {
        return await onSuccessfulResponse(response);
      } else if (response.statusCode == 401) {
        print('Invalid credentials');
        return false;
      } else if (response.statusCode == 404) {
        print('User not found');
        return false;
      } else {
        print('Login failed: ${response.body}');
        return false;
      }
    } on http.ClientException catch (e) {
      print('Network error: $e');
      return false;
    } on TimeoutException catch (e) {
      print('Request timed out: $e');
      return false;
    } catch (e) {
      print('Unexpected error: $e');
      return false;
    }
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
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
          'isValidated': false,
          'roleType': 'USER',
        }),
      );

      if (response.statusCode == 200) {
        return await onSuccessfulResponse(response);
      }
    } catch (e) {
      print('Registration error: $e');
    }
    return false;
  }

  Future<bool> onSuccessfulResponse(http.Response response) async {
    final data = jsonDecode(response.body);
    final token = data['token'];

    await _storage.write(key: 'token', value: token);
    _currentUser = User.fromJson(data['user'], token);

    return true;
  }

  Map<String, String> get authHeaders =>
      {'Authorization': 'Bearer ${_currentUser?.token ?? ''}'};

  bool isTokenValid(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return false;

      final payload = json
          .decode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));

      final expiry = DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000);
      return DateTime.now().isBefore(expiry);
    } catch (e) {
      return false;
    }
  }
}
