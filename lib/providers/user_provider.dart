import 'package:finbedu/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_service.dart'; // Pastikan path-nya benar

class UserProvider with ChangeNotifier {
  UserModel? _user;
  List<UserModel> _mentors = [];

  UserModel? get user => _user;
  List<UserModel> get mentors => _mentors;

  void setUser(UserModel userData) {
    _user = userData;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }


  Future<void> fetchMentors() async {
    try {
      final userService = UserService();
      _mentors = await userService.fetchMentors();
      notifyListeners();
    } catch (e) {
      print('Error fetching mentors: $e');
      rethrow;
    }
  }

}
