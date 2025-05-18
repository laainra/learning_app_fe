import 'package:flutter/material.dart';
import '../models/course_access.dart';
import '../services/access_service.dart';

class AccessProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool _isEnrolled = false;
  bool get isEnrolled => _isEnrolled;

  // Fungsi untuk cek apakah user sudah enroll
  Future<void> checkUserEnrollment(int courseId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final enrolled = await checkEnrollment(courseId);
      _isEnrolled = enrolled;
    } catch (e) {
      _errorMessage = 'Gagal mengecek enrollment: $e';
      _isEnrolled = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  // Fungsi untuk menambahkan CourseAccess
  Future<int?> addAccess(CourseAccess access) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final accessId = await addCourseAccess(access);
      if (accessId != null) {
        // Berhasil
        print('Access berhasil ditambahkan dengan ID: $accessId');
        return accessId;
      } else {
        _errorMessage = 'Gagal menambahkan akses.';
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
    }

    _isLoading = false;
    notifyListeners();
    return null;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
