import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:finbedu/models/review_model.dart';
import 'constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ReviewService {
  final storage = const FlutterSecureStorage();
  final String baseUrl = Constants.baseUrl;
  Future<List<Review>> fetchAllReviews() async {
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('$baseUrl/reviews'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => Review.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat review');
    }
  }

  Future<List<Review>> fetchReviewsByCourse(int courseId) async {
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('$baseUrl/reviews/course/$courseId'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => Review.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat review course');
    }
  }

  Future<Review> postReview({
    required String reviews,
    required int rating,
    required int courseId,
  }) async {
    final token = await storage.read(key: 'token');
    final response = await http.post(
      Uri.parse('$baseUrl/reviews'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: {
        'reviews': reviews,
        'rating': rating.toString(),
        'course_id': courseId.toString(),
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body)['data'];
      return Review.fromJson(data);
    } else {
      try {
        // Coba ambil pesan dari API jika tersedia
        final error = json.decode(response.body);
        final message = error['message'] ?? 'Gagal menambahkan review';
        throw Exception(message);
      } catch (e) {
        // Kalau parsing JSON gagal, fallback ke pesan umum
        throw Exception('Gagal menambahkan review (${response.statusCode})');
      }
    }
  }

  Future<void> deleteReview(int id) async {
    final token = await storage.read(key: 'token');
    final response = await http.delete(
      Uri.parse('$baseUrl/reviews/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus review');
    }
  }
}
