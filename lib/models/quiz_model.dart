import 'package:finbedu/models/section_model.dart';

import 'quiz_question_model.dart';

class Quiz {
  final int id;
  final int sectionId;
  final Section section; // Tambahkan properti section
  final List<QuizQuestion> questions;

  Quiz({
    required this.id,
    required this.sectionId,
    required this.section,
    required this.questions,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      sectionId:
          json['section_id'] is String
              ? int.tryParse(json['section_id'])
              : json['section_id'],
      section: Section.fromJson(json['section']), // Parsing section
      questions:
          (json['questions'] as List<dynamic>)
              .map((q) => QuizQuestion.fromJson(q))
              .toList(),
    );
  }
}
