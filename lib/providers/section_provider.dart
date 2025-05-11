import 'package:flutter/material.dart';
import 'package:finbedu/models/section_model.dart';
import 'package:finbedu/services/section_service.dart';

class SectionProvider with ChangeNotifier {
  final SectionService _service = SectionService();
  List<Section> sections = [];

  Future<void> fetchSections(int courseId) async {
    sections = await _service.fetchSections(courseId);
    notifyListeners();
  }

  Future<void> addSection(int courseId, String name) async {
    await _service.addSection(courseId, name);
    await fetchSections(courseId);
  }

  Future<void> updateSection(int sectionId, String name) async {
  await _service.updateSection(sectionId, name);
  notifyListeners();
}

Future<void> deleteSection(int sectionId) async {
  await _service.deleteSection(sectionId);
  notifyListeners();
}

}