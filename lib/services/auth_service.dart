import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constants.dart'; // Import the constants file
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  Future<bool> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      // Debugging the URL
      final url = '${Constants.baseUrl}/login';
      print('Attempting to login with URL: $url');

      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is Map &&
            data.containsKey('status') &&
            data['status'] == true) {
          final userData = UserModel.fromJson(data['data']['user']);
          final token = data['data']['token'];

          await storage.write(key: 'token', value: token);
          await storage.write(key: 'role', value: userData.role);
          await storage.write(key: 'isLoggedIn', value: 'true');
          await storage.write(key: 'user_id', value: userData.id.toString());

          Provider.of<UserProvider>(context, listen: false).setUser(userData);
          return true;
        } else {
          print('Login failed: ${data['message']}');
          throw Exception(data['message']);
        }
      } else {
        print('Failed to login: ${response.statusCode}');
        print('Response body: ${response.body}');

        final errorMessage = _getErrorMessage(response.body);
        throw Exception(errorMessage);
      }
    } catch (error) {
      print('Error during login: $error');
      throw Exception('An error occurred during login: $error');
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      final token = await storage.read(key: 'token');
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Clear the token from storage
        await storage.delete(key: 'token');
        Provider.of<UserProvider>(context, listen: false).clearUser();
      } else {
        print('Failed to logout: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during logout: $error');
    }
  }

  Future<bool> register(
    String name,
    String email,
    String password,
    String? role,
  ) async {
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/register'),
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      // Registration successful
      return true;
    } else {
      // Registration failed, log the response for debugging
      print('Failed to register: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Optional: you can also show the error message if available
     final errorMessage = _getErrorMessage(response.body);
    throw Exception(errorMessage);
    }
  }

String _getErrorMessage(String responseBody) {
  try {
    final Map<String, dynamic> json = jsonDecode(responseBody);
    if (json.containsKey('errors')) {
      final errors = json['errors'] as Map<String, dynamic>;
      final messages = errors.values.expand((v) => v).join('\n');
      return messages;
    } else if (json.containsKey('message')) {
      return json['message'];
    }
    return 'Registration failed. Please try again.';
  } catch (e) {
    return 'Something went wrong.';
  }
}
}
