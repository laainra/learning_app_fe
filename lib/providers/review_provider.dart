import 'package:flutter/material.dart';
import 'package:finbedu/models/review_model.dart';
import 'package:finbedu/services/review_service.dart';

class ReviewProvider with ChangeNotifier {
  List<Review> _reviews = [];
  bool _isLoading = false;
  String? _errorMessage; // Field privat (sudah benar)

  // Getter publik untuk field di atas
  List<Review> get reviews => _reviews;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage; // <--- TAMBAHKAN BARIS INI

  final ReviewService _service = ReviewService();

  Future<void> loadReviews({int? courseId}) async {
    _isLoading = true;
    _errorMessage = null; // Reset error message di awal
    notifyListeners();

    try {
      if (courseId != null) {
        
        _reviews = await _service.fetchReviewsByCourse(courseId);
      } else {
        _reviews = await _service.fetchAllReviews();
      }
    } catch (e) {
      _reviews = [];
      _errorMessage = e.toString();
      print('Error loading reviews: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addReview({
    required String reviews,
    required int rating,
    required int courseId,
  }) async {
    // Tambahkan _isLoading dan _errorMessage handling di sini jika diperlukan
    // bool wasSuccessful = false;
    // String? operationError;
    try {
      final newReview = await _service.postReview(
        reviews: reviews,
        rating: rating,
        courseId: courseId,
      );
      _reviews.insert(
        0,
        newReview,
      ); // Lebih baik insert di awal agar langsung terlihat
      // wasSuccessful = true;
    } catch (e) {
      // operationError = e.toString();
      print('Error adding review: $e');
      rethrow; // Biarkan UI yang memanggil menangani error spesifik jika perlu
    } finally {
      notifyListeners(); // Panggil notifyListeners di akhir, setelah semua perubahan state
    }
  }

  Future<void> removeReview(int id) async {
    try {
      await _service.deleteReview(id);
      _reviews.removeWhere((review) => review.id == id);
    } catch (e) {
      print('Error removing review: $e');
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  double get averageRating {
    if (_reviews.isEmpty) return 0.0;
    return _reviews.map((r) => r.rating).reduce((a, b) => a + b) /
        _reviews.length;
  }

  int get totalReviews => _reviews.length;
}
