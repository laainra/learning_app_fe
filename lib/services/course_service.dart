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
  Future<Map<String, List<Course>>> fetchStudentCourses(int userId) async {
    final token = await storage.read(key: 'token');
    final url = Uri.parse('${Constants.baseUrl}/student-courses/$userId');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('Fetch student courses - Status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Pastikan ongoing/completed selalu List, walau kosong
      final ongoingList = (data['ongoing'] as List?) ?? [];
      final completedList = (data['completed'] as List?) ?? [];
      return {
        'ongoing':
            ongoingList
                .where((e) => e != null)
                .map((e) => Course.fromJson(e as Map<String, dynamic>))
                .toList(),
        'completed':
            completedList
                .where((e) => e != null)
                .map((e) => Course.fromJson(e as Map<String, dynamic>))
                .toList(),
      };
    } else {
      throw Exception('Failed to load student courses');
    }
  }

  Future<List<Course>> fetchCourse() async {
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/courses'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Course.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load courses: ${response.body}');
    }
  }

  Future<int?> addCourse(Course course) async {
    try {
      // Print the course data as JSON
      print(course.toJson());

      final token = await storage.read(key: 'token');
      final url = Uri.parse('${Constants.baseUrl}/courses');

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
        Uri.parse('${Constants.baseUrl}/courses/${course.id}'),
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
        Uri.parse('${Constants.baseUrl}/courses/$courseId'),
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

  Future<bool> uploadCourseImage(int courseId, File imageFile) async {
    try {
      final token = await storage.read(key: 'token');
      final uri = Uri.parse(
        '${Constants.baseUrl}/courses/$courseId/upload-image',
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
        Uri.parse('${Constants.baseUrl}/sections'),
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
        Uri.parse('${Constants.baseUrl}/videos'),
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
      final token = await storage.read(key: 'token');

      final url = Uri.parse('${Constants.baseUrl}/courses/mentor/$mentorId');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        return data.map((json) => Course.fromJson(json)).toList();
      } else {
        print('Failed to fetch courses. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching courses: $e');
      return [];
    }
  }

  Future<List<Course>> fetchCourseByCategory(int categoryId) async {
    try {
      final token = await storage.read(key: 'token');
      final url = Uri.parse(
        '${Constants.baseUrl}/categories/$categoryId/courses',
      );

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
      );

      print('Fetch courses by category - Status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        return data.map((json) => Course.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load courses by category: ${response.body}');
      }
    } catch (e) {
      print('Error fetching courses by category: $e');
      return [];
    }
  }

  Future<Course?> fetchCourseById(int courseId) async {
    try {
      final token = await storage.read(key: 'token');
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/courses/$courseId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
      );

      print('Fetch course by ID - Status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Course.fromJson(data);
      } else {
        print('Failed to fetch course: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching course by ID: $e');
      return null;
    }
  }
}
