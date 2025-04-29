import 'dart:io';
import 'package:finbedu/services/course_service.dart';
import 'package:flutter/material.dart';

class CourseImageProvider with ChangeNotifier {
  final CourseService _courseImageService = CourseService();

  bool _isUploading = false;
  bool get isUploading => _isUploading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> uploadImage(int courseId, File imageFile) async {
    _isUploading = true;
    _errorMessage = null;
    notifyListeners();

    final success = await _courseImageService.uploadCourseImage(courseId, imageFile);

    _isUploading = false;
    if (!success) {
      _errorMessage = 'Failed to upload image.';
    }
    notifyListeners();

    return success;
  }
}
