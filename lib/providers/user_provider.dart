import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart'; // Pastikan path-nya benar
import 'dart:io';


class UserProvider with ChangeNotifier {
  UserModel? _user;
  List<UserModel> _mentors = [];

  UserModel? get user => _user;
  List<UserModel> get mentors => _mentors;
  final userService = UserService();

  void setUser(UserModel userData) {
    _user = userData;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  Future<void> fetchProfile() async {
    try {
 
      _user = await userService.fetchProfile();
      notifyListeners();
    } catch (e) {
      print('Error fetching profile: $e');
      rethrow;
    }
  }

  Future<void> updateProfile({
    required String name,
    required String dob,
    required String email,
    required String noTelp,
    required String? gender,
  }) async {
    
    final success = await userService.updateProfile({
      'name': name,
      'dob': dob,
      'email': email,
      'no_telp': noTelp,
      'gender': gender,
    });

    if (success) {
      await fetchProfile(); // refresh data setelah update berhasil
    }
  }
 Future<bool> uploadUserImage(int userId, File imageFile) async {
  try {
    return await userService.uploadImage(userId, imageFile); // fungsi yang kamu buat sebelumnya
  } catch (e) {
    rethrow; // teruskan exception agar bisa ditangkap di _uploadImage
  }
}

  Future<List<UserModel>> fetchMentors() async {
    try {
      final userService = UserService();
      _mentors = await userService.fetchMentors();
      notifyListeners();
      return _mentors; // Ensure the method returns the list of mentors
    } catch (e) {
      print('Error fetching mentors: $e');
      rethrow;
    }
  }
}
