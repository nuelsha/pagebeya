import 'package:flutter/material.dart';
import 'package:pagebeya/data/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pagebeya/data/services/network_exceptions.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  User? _user;
  bool _isLoading = false;

  String? get token => _token;
  User? get user => _user;
  bool get isLoading => _isLoading;

  final String baseUrl = 'https://1clr2kph-3005.uks1.devtunnels.ms/auth';

  Future<void> signUp(
      String name, String phone, String email, String password) async {
    try {
      _setLoading(true);
      final response = await http
          .post(
            Uri.parse(baseUrl),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'name': name,
              'phoneNum': phone,
              'email': email,
              'password': password,
              'image': ''
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 201) {
        await _handleSuccessfulAuth(response);
      } else {
        final errorData = json.decode(response.body);
        throw NetworkException(errorData['message'] ?? 'Registration failed');
      }
    } catch (e) {
      _setLoading(false);
      throw NetworkException(NetworkException.handleError(e));
    }
  }

  Future<void> login(String phone, String password) async {
    try {
      _setLoading(true);
      final response = await http
          .post(
            Uri.parse('$baseUrl/login'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'phoneNum': phone, 'password': password}),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        await _handleSuccessfulAuth(response);
      } else {
        final errorData = json.decode(response.body);
        throw NetworkException(errorData['message'] ?? 'Authentication failed');
      }
    } catch (e) {
      _setLoading(false);
      throw NetworkException(NetworkException.handleError(e));
    }
  }

  Future<void> _handleSuccessfulAuth(http.Response response) async {
    final data = json.decode(response.body);
    _token = data['token'];
    await fetchUserData();
    _setLoading(false);
  }

  Future<void> fetchUserData() async {
    if (_token == null) return;

    try {
      _setLoading(true);
      final response = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        _user = User.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to fetch user data');
      }
    } catch (e) {
      _user = null;
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    _setLoading(false);
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
