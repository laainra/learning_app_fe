import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'constants.dart';
import '../models/user_model.dart'; // Pastikan ini path ke model User

class UserService {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<List<UserModel>> fetchMentors() async {
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/mentors'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List<dynamic> data = decoded['data'];
      return data.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load mentors: ${response.body}');
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    final token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception("User not authenticated.");
    }

    final url = Uri.parse('${ApiConstants.baseUrl}/edit/profile');
    print('Attempting to update profile at: $url');
    print('Data to be sent: $data');

    final response = await http
        .put(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(data),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      try {
        final decoded = jsonDecode(response.body);
        if (decoded['status'] == true) {
          return true;
        } else {
          throw Exception(decoded['message'] ?? 'Failed to update profile.');
        }
      } catch (e) {
        throw Exception('Invalid response format: ${response.body}');
      }
    } else {
      try {
        final errorData = jsonDecode(response.body);
        if (errorData['errors'] != null && errorData['errors'] is Map) {
          final firstError = (errorData['errors'] as Map).values.first;
          if (firstError is List && firstError.isNotEmpty) {
            throw Exception(firstError.first);
          }
        }
        throw Exception(
          errorData['message'] ?? 'Error: ${response.statusCode}',
        );
      } catch (_) {
        throw Exception('Unexpected error: ${response.body}');
      }
    }
  }
}
