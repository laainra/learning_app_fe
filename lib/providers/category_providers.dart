// category_provider.dart
import 'package:flutter/material.dart';
import '../models/category_model.dart' as catModel;
import '../services/category_service.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryService _categoryService = CategoryService();
  List<catModel.Category> _categories = [];

  List<catModel.Category> get categories => _categories;

  Future<void> fetchCategories() async {
    _categories = await _categoryService.fetchCategories();
    notifyListeners();
  }

  Future<void> addCategory(String name) async {
    await _categoryService.addCategory(name);
    await fetchCategories(); // Refresh the list after adding
  }
}