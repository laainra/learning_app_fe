// category_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/category_model.dart';
import 'constants.dart'; // Make sure to import your API constants
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CategoryService {
  final storage = const FlutterSecureStorage();
  Future<List<Category>> fetchCategories() async {
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/categories'),
      headers: {
        //  'Authorization': 'Bearer $token',
        'Accept': 'application/json',
  'X-Requested-With': 'XMLHttpRequest',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories: ${response.body}');
    }
  }

  Future<void> addCategory(String name) async {
    final token = await storage.read(key: 'token');
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/categories'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add category');
    }
  }
}
