import 'package:finbedu/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  void setUser(UserModel userData) {
    _user = userData;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  
Future<List<UserModel>> fetchMentors() async {
  try {
    final authService = AuthService(); // Buat instance AuthService
    final mentors = await authService.fetchMentors(); // Panggil metode melalui instance
    return mentors;
  } catch (e) {
    print('Error fetching mentors: $e');
    rethrow;
  }
}
}
