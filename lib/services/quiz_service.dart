import 'dart:convert';
import 'package:finbedu/models/quiz_answer_model.dart';
import 'package:finbedu/models/quiz_model.dart';
import 'package:finbedu/models/quiz_question_model.dart';
import 'package:finbedu/services/constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class QuizService {
  static const String baseUrl = ApiConstants.baseUrl;
    final storage = const FlutterSecureStorage();

  // Fetch quizzes
  Future<List<Quiz>> fetchQuizzes(int sectionId) async {
        final token = await storage.read(key: 'token');
    final url = Uri.parse('$baseUrl/videos?section_id=$sectionId');
    final response = await http.get(url,headers: {'Authorization': 'Bearer $token','Content-Type': 'application/json'},);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Quiz.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch quizzes');
    }
  }

  // Add a new quiz
  Future<void> addQuiz(int sectionId) async {
        final token = await storage.read(key: 'token');
    final url = Uri.parse('$baseUrl/quizzes');
    final response = await http.post(
      url,
      body: jsonEncode({'section_id': sectionId}),
      headers: {'Authorization': 'Bearer $token','Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {

      final data = jsonDecode(response.body);
      return data['id']; // Return the ID of the created quiz
    } else {
      throw Exception('Failed to create quiz');
    }
  }

  // Fetch quiz questions for a specific quiz
  Future<List<QuizQuestion>> fetchQuestions(int quizId) async {
        final token = await storage.read(key: 'token');
    final url = Uri.parse('$baseUrl/quiz-questions?quiz_id=$quizId');
    final response = await http.get(url,headers: {'Authorization': 'Bearer $token','Content-Type': 'application/json'},);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => QuizQuestion.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch questions');
    }
  }

    Future<int> addQuestion(int quizId, String question) async {
    final token = await storage.read(key: 'token');
    final url = Uri.parse('$baseUrl/quiz_questions');
    final response = await http.post(
      url,
      body: jsonEncode({'quiz_id': quizId, 'question': question}),
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['id']; // Return the ID of the created question
    } else {
      throw Exception('Failed to add question');
    }
  }

    Future<List<QuizAnswer>> fetchAnswers(int quizQuestionId) async {
        final token = await storage.read(key: 'token');
    final url = Uri.parse('$baseUrl/quiz-answers?quiz_question_id=$quizQuestionId');
    final response = await http.get(url,headers: {'Authorization': 'Bearer $token','Content-Type': 'application/json'},);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => QuizAnswer.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch questions');
    }
  }

  // Add answer to question
  Future<void> addAnswer(int quizQuestionId, String answer, bool status) async {
        final token = await storage.read(key: 'token');
    final url = Uri.parse('$baseUrl/quiz-answers');
    final response = await http.post(
      url,
      body: jsonEncode({
        'quiz_question_id': quizQuestionId,
        'answer': answer,
        'status': status,
      }),
      headers: {'Authorization': 'Bearer $token','Content-Type': 'application/json'},
    );

        if (response.statusCode != 201) {
      throw Exception('Failed to add answer');
    }
  }
}
