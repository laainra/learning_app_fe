import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'constants.dart';
import '../models/user_model.dart';
import 'package:mime_type/mime_type.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

class UserService {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<List<UserModel>> fetchMentors() async {
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/mentors'),
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

  Future<UserModel> fetchProfile() async {
    final token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception("User not authenticated.");
    }

    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/profile'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(
        data,
      ); // Pastikan `UserModel` memiliki `fromJson`
    } else {
      throw Exception('Failed to fetch profile: ${response.body}');
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    final token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception("User not authenticated.");
    }

    final url = Uri.parse('${Constants.baseUrl}/edit/profile');
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

  Future<bool> uploadImage(int userId, File imageFile) async {
    final token = await storage.read(key: 'token');
    final uri = Uri.parse(
      '${Constants.baseUrl}/upload-image/$userId',
    ); // ganti dengan base URL kamu
    final request = http.MultipartRequest('POST', uri);
    var mimeType = mime(imageFile.path) ?? 'application/octet-stream';
    var mimeTypeData = mimeType.split('/');
    var multipartFile = http.MultipartFile(
      'photo',
      imageFile.openRead(),
      await imageFile.length(),
      filename: imageFile.path.split('/').last,
      contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
    );
    request.files.add(multipartFile);
    request.headers['Authorization'] = 'Bearer $token';

    final response = await request.send();
    if (response.statusCode == 200) {
      print('Image uploaded successfully');
      return true;
    } else {
      print('Failed to upload image. Status code: ${response.statusCode}');
      print('Response body: ${await response.stream.bytesToString()}');
      return false;
    }
  }
}
