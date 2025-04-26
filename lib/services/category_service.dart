// category_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/category_model.dart';
import 'constants.dart'; // Make sure to import your API constants

class CategoryService {
  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('${ApiConstants.baseUrl}/categories'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<void> addCategory(String name) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/categories'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add category');
    }
  }
}