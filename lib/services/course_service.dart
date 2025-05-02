import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import '../models/course_model.dart';
import 'constants.dart';
import 'package:flutter/foundation.dart';

class CourseService {
  final storage = const FlutterSecureStorage();
  Future<int?> addCourse(Course course) async {
    try {
      // Print the course data as JSON
      print(course.toJson());

      final token = await storage.read(key: 'token');
      final url = Uri.parse('${ApiConstants.baseUrl}/courses');

      // Send POST request with the Course data as JSON
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(course.toJson()), // Convert Course to JSON
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print('Course created successfully: $responseData');
        return responseData['data']['id'];
      } else {
        print('Failed to create course. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error creating course: $e');
      return null;
    }
  }

  Future<bool> updateCourse(Course course) async {
    try {
      final token = await storage.read(key: 'token');
      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}/courses/${course.id}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(course.toJson()),
      );

      if (response.statusCode == 200) {
        print('Succcess to update course: ${response.statusCode}');
        print('Response body: ${response.body}');
        return true;
      } else {
        print('Failed to update course: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error updating course: $e');
      return false;
    }
  }

  Future<bool> deleteCourse(int courseId) async {
    try {
      final token = await storage.read(key: 'token');
      final response = await http.delete(
        Uri.parse('${ApiConstants.baseUrl}/courses/$courseId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Course deleted successfully');
        return true;
      } else {
        print('Failed to delete course: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error deleting course: $e');
      return false;
    }
  }

  // Upload Course Image
  Future<bool> uploadCourseImage(int courseId, File imageFile) async {
    try {
      final token = await storage.read(key: 'token');
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}/courses/$courseId/upload-image',
      );
      final request = http.MultipartRequest('POST', uri);

      // Menambahkan file gambar
      var mimeType = mime(imageFile.path) ?? 'application/octet-stream';
      var mimeTypeData = mimeType.split('/');
      var multipartFile = http.MultipartFile(
        'image',
        imageFile.openRead(),
        await imageFile.length(),
        filename: imageFile.path.split('/').last,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
      );
      request.files.add(multipartFile);

      // Tambahkan header
      request.headers['Authorization'] = 'Bearer $token';

      // Kirim request
      final response = await request.send();
      if (response.statusCode == 200) {
        print('Image uploaded successfully');
        return true;
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
        print('Response body: ${await response.stream.bytesToString()}');
        return false;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return false;
    }
  }

  // Create Section
  Future<bool> createSection(String name, int courseId) async {
    try {
      final token = await storage.read(key: 'token');
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/sections'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'name': name, 'course_id': courseId}),
      );

      if (response.statusCode == 201) {
        print('Section created successfully');
        return true;
      } else {
        print('Failed to create section. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error creating section: $e');
      return false;
    }
  }

  // Create Video
  Future<bool> createVideo(
    String title,
    String url,
    int sectionId,
    String duration,
  ) async {
    try {
      final token = await storage.read(key: 'token');
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/videos'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'title': title,
          'url': url,
          'section_id': sectionId,
          'duration': duration,
        }),
      );

      if (response.statusCode == 201) {
        print('Video created successfully');
        return true;
      } else {
        print('Failed to create video. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error creating video: $e');
      return false;
    }
  }

  Future<List<Course>> fetchCoursesByMentor(int mentorId) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}/courses/mentor/$mentorId');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return compute(_parseCourses, response.body);
      } else {
        throw Exception('Failed to load courses');
      }
    } catch (e) {
      print('Error fetching courses: $e');
      throw e; // Rethrow the error to be handled in the UI
    }
  }

  List<Course> _parseCourses(String responseBody) {
    final List<dynamic> data = jsonDecode(responseBody)['data'];
    return data.map((json) => Course.fromJson(json)).toList();
  }
}
