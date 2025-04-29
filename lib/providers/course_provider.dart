import 'dart:io';
import 'package:finbedu/models/course_model.dart';
import 'package:finbedu/services/course_service.dart';
import 'package:flutter/material.dart';

class CourseProvider with ChangeNotifier {
  final CourseService _courseService = CourseService();


  List<Course> _mentorCourses = [];
  List<Course> get mentorCourses => _mentorCourses;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchCoursesByMentor(int mentorId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _mentorCourses = await _courseService.fetchCoursesByMentor(mentorId);
    } catch (e) {
      print('Error fetching mentor courses: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<int?> createCourse(Course course) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulasi proses pembuatan course
      final courseId = await _courseService.addCourse(course);
      return courseId;
    } catch (e) {
      print('Error creating course: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> uploadCourseImage(int courseId, File imageFile) async {
    return await _courseService.uploadCourseImage(courseId, imageFile);
  }
}
