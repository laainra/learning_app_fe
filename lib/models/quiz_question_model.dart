import 'package:finbedu/models/quiz_answer_model.dart';

class QuizQuestion {
  final int id;
  final String question;
  final int quizId;
   final List<QuizAnswer> answers; // Tambahkan properti ini


  QuizQuestion({required this.id, required this.question, required this.quizId,  required this.answers,});

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'],
      question: json['question'],
      quizId: json['quiz_id'] is String
              ? int.tryParse(json['quiz_id'])
              : json['quiz_id'],
      answers: (json['answers'] as List<dynamic>)
          .map((answerJson) => QuizAnswer.fromJson(answerJson))
          .toList(),
    );
  }
}
