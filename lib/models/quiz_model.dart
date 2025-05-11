import 'quiz_question_model.dart';

class Quiz {
  final int id;
  final String sectionName;
  final List<QuizQuestion> questions;

  Quiz({
    required this.id,
    required this.sectionName,
    required this.questions,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      sectionName: json['section']['name'],
      questions: (json['questions'] as List<dynamic>)
          .map((q) => QuizQuestion.fromJson(q))
          .toList(),
    );
  }
}