import 'dart:io';
import 'package:finbedu/models/course_model.dart';
import 'package:finbedu/services/course_service.dart';
import 'package:flutter/material.dart';

class CourseProvider with ChangeNotifier {
  final CourseService _courseService = CourseService();

  List<Course> _mentorCourses = [];
  List<Course> get mentorCourses => _mentorCourses;

  List<Course> _allCourses = [];
  List<Course> get allCourses => _allCourses;

  List<Course> _categoryCourses = []; // NEW
  List<Course> get categoryCourses => _categoryCourses; // NEW

  Course? _courseById; // NEW
  Course? get courseById => _courseById; // NEW

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Future<void> fetchCoursesByMentor(int mentorId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final courses = await _courseService.fetchCoursesByMentor(mentorId);
      _mentorCourses = courses;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error fetching courses: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCourses() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allCourses = await _courseService.fetchCourse();
    } catch (e) {
      print('Error fetching all courses: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCoursesByCategory(int categoryId) async {
    // NEW
    _isLoading = true;
    notifyListeners();

    try {
      _categoryCourses = await _courseService.fetchCourseByCategory(categoryId);
    } catch (e) {
      print('Error fetching courses by category: $e');
      _categoryCourses = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCourseById(int courseId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final course = await _courseService.fetchCourseById(courseId);
      _courseById = course;
    } catch (e) {
      print('Error fetching course by ID: $e');
      _courseById = null;
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

  Future<bool> updateCourse(Course course) async {
    notifyListeners();
    final result = await _courseService.updateCourse(course);
    if (result) {
      await fetchCoursesByMentor(course.userId!);
      notifyListeners();
    }
    return result;
  }

  Future<bool> deleteCourse(int courseId, int mentorId) async {
    try {
      final success = await _courseService.deleteCourse(courseId);
      if (success) {
        _mentorCourses.removeWhere((course) => course.id == courseId);
        await fetchCoursesByMentor(mentorId);
        notifyListeners();
        return true; // Kembalikan true jika berhasil
      }
      return false; // Kembalikan false jika gagal
    } catch (e) {
      print('Error deleting course: $e');
      return false; // Kembalikan false jika terjadi error
    }
  }

  Future<bool> uploadCourseImage(int courseId, File imageFile) async {
    return await _courseService.uploadCourseImage(courseId, imageFile);
  }
}
