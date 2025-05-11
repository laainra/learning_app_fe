import 'dart:convert';
import 'package:finbedu/models/section_model.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SectionService {
  final storage = const FlutterSecureStorage();

  Future<List<Section>> fetchSections(int courseId) async {
    final token = await storage.read(key: 'token');
    final url = Uri.parse('${ApiConstants.baseUrl}/sections?course_id=$courseId');
    final response = await http.get(
      url,
      headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print('Fetched sections: $data');
      return data.map((json) => Section.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch sections');
    }
  }

  Future<void> addSection(int courseId, String name) async {
  try {
    final token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token is null. Please log in again.');
    }

    final url = Uri.parse('${ApiConstants.baseUrl}/courses/$courseId/sections');
    print('Sending request to: $url');
    print('Token: $token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'name': name}),
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 201) {
      throw Exception('Failed to add section. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error adding section: $e');
    rethrow; // Rethrow the error to be handled by the caller
  }
}
Future<void> updateSection(int sectionId, String name) async {
  try {
    final token = await storage.read(key: 'token');
    final url = Uri.parse('${ApiConstants.baseUrl}/sections/$sectionId');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update section. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error updating section: $e');
    rethrow;
  }
}

Future<void> deleteSection(int sectionId) async {
  try {
    final token = await storage.read(key: 'token');
    final url = Uri.parse('${ApiConstants.baseUrl}/sections/$sectionId');
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete section. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error deleting section: $e');
    rethrow;
  }
}

}
