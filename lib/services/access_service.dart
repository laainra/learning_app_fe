import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/course_access.dart';
import 'constants.dart'; // Berisi baseUrl
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

Future<int?> addCourseAccess(CourseAccess access) async {
  try {
    // Baca token dari secure storage
    final token = await storage.read(key: 'token');
    if (token == null) {
      print('Token tidak ditemukan. Harap login terlebih dahulu.');
      return null;
    }

    // Buat URL endpoint
    final url = Uri.parse('${Constants.baseUrl}/course-accesses');

    // Kirim request POST ke API
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(access.toJson()),
    );

    // Cek respons
    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      print('Akses course berhasil ditambahkan: ${responseData['data']}');
      return responseData['data']['id'];
    } else {
      print('Gagal menambahkan akses. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null;
    }
  } catch (e) {
    print('Terjadi kesalahan saat menambahkan akses course: $e');
    return null;
  }
}

Future<bool> checkEnrollment(int courseId) async {
  try {
    final token = await storage.read(key: 'token');
    if (token == null) {
      print('Token tidak ditemukan. Harap login terlebih dahulu.');
      return false;
    }

    final url = Uri.parse(
      '${Constants.baseUrl}/course-access/enrolled/check-enrollment?course_id=$courseId',
    );

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['enrolled'] ?? false;
    } else {
      print('Gagal cek enrollment. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Error saat cek enrollment: $e');
    return false;
  }
}
