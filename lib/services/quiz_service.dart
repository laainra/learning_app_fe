import 'dart:convert';
import 'package:finbedu/models/quiz_answer_model.dart';
import 'package:finbedu/models/quiz_model.dart';
import 'package:finbedu/models/quiz_question_model.dart';
import 'package:finbedu/services/constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class QuizService {
  static const String baseUrl = Constants.baseUrl;
  final storage = const FlutterSecureStorage();

  // Fetch quizzes
  Future<List<Quiz>> fetchQuizzes(int sectionId) async {
    final token = await storage.read(key: 'token');
    final url = Uri.parse('$baseUrl/videos?section_id=$sectionId');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Quiz.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch quizzes');
    }
  }

  Future<List<QuizAnswer>> getAnswersByQuestionId(int questionId) async {
    try {
      final token = await storage.read(key: 'token');
      final url = Uri.parse('$baseUrl/questions/$questionId/answers');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => QuizAnswer.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load answers');
      }
    } catch (e) {
      print('Error fetching answers: $e');
      throw Exception('Failed to fetch answers');
    }
  }

  Future<int> addQuiz(int sectionId) async {
    final token = await storage.read(key: 'token');
    final url = Uri.parse('$baseUrl/quizzes/get-or-create');
    final response = await http.post(
      url,
      body: jsonEncode({'section_id': sectionId}),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['id'];
    } else {
      throw Exception('Failed to create quiz');
    }
  }

  // Fetch quiz questions for a specific quiz
  Future<List<QuizQuestion>> fetchQuestions(int quizId) async {
    final token = await storage.read(key: 'token');
    final url = Uri.parse('$baseUrl/quiz-questions?quiz_id=$quizId');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

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
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
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
    final url = Uri.parse(
      '$baseUrl/quiz-answers?quiz_question_id=$quizQuestionId',
    );
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

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
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add answer');
    }
  }

  // Update question
  Future<void> updateQuestion(int questionId, String question) async {
    final token = await storage.read(key: 'token');
    final url = Uri.parse('${Constants.baseUrl}/questions/$questionId');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'question': question}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update question');
    }
  }

  // Delete question
  Future<void> deleteQuestion(int questionId) async {
    final token = await storage.read(key: 'token');
    final url = Uri.parse('${Constants.baseUrl}/quiz-questions/$questionId');
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete question');
    }
  }

  // Update answer
  Future<void> updateAnswer(int answerId, String answer) async {
    final token = await storage.read(key: 'token');
    final url = Uri.parse('${Constants.baseUrl}/answers/$answerId');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'answer': answer}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update answer');
    }
  }

  // Delete answer
  Future<void> deleteAnswer(int answerId) async {
    final token = await storage.read(key: 'token');
    final url = Uri.parse('${Constants.baseUrl}/answers/$answerId');
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete answer');
    }
  }

  Future<void> addQuestionWithAnswers(
    int quizId,
    String question,
    List<Map<String, dynamic>> answers,
  ) async {
    final token = await storage.read(key: 'token');
    final url = Uri.parse('$baseUrl/quizzes/$quizId/questions');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'question': question, 'answers': answers}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add question with answers');
    }
  }

  Future<void> editQuestionWithAnswers(
    int quizId,
    int questionId,
    String question,
    List<Map<String, dynamic>> answers,
  ) async {
    final token = await storage.read(key: 'token');
    final url = Uri.parse('$baseUrl/quizzes/$quizId/questions/$questionId');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'question': question, 'answers': answers}),
    );
    // print('Response body quiz: ${response.body}');
    print('Response status code quiz: ${response.statusCode}');
    if (response.statusCode != 200) {
      throw Exception('Failed to edit question');
    }
  }

  Future<Quiz> fetchQuizDetails(int quizId) async {
    final token = await storage.read(key: 'token');
    final url = Uri.parse('$baseUrl/quizzes/$quizId/details');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return Quiz.fromJson(data);
    } else {
      throw Exception('Failed to fetch quiz details');
    }
  }

  Future<List<dynamic>> fetchQuizResults() async {
    final token = await storage.read(key: 'token');
    final url = Uri.parse('$baseUrl/quiz-results');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return data;
    } else {
      throw Exception('Failed to fetch quiz results');
    }
  }

  Future<Map<String, dynamic>> fetchQuizResultByQuizId(int quizId) async {
    final token = await storage.read(key: 'token');
    final url = Uri.parse('$baseUrl/quiz-results/$quizId');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print('Response status code: ${response.statusCode} for quizId: $quizId');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return data;
    } else if (response.statusCode == 404) {
      throw Exception('Quiz result not found');
    } else {
      throw Exception('Failed to fetch quiz result');
    }
  }

  Future<Map<String, dynamic>> submitQuiz(
    int quizId,
    List<Map<String, int>> answers,
  ) async {
    final token = await storage.read(key: 'token');
    final url = Uri.parse('$baseUrl/quiz-results');

    final client = http.Client();
    final request = http.Request('POST', url);
    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    request.body = jsonEncode({'quiz_id': quizId, 'answers': answers});

    final streamedResponse = await client.send(request);
    final response = await http.Response.fromStream(streamedResponse);

    print('Status code: ${response.statusCode}');
    print('Headers: ${response.headers}');
    print('Body: ${response.body}');

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to submit quiz');
    }
  }

  Future<int?> getQuizIdBySectionId(int sectionId) async {
    final token = await storage.read(key: 'token');
    final url = Uri.parse('$baseUrl/quiz-id/$sectionId');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['quiz_id']; // Kembalikan quizId
    } else if (response.statusCode == 404) {
      return null; // Jika quiz tidak ditemukan, kembalikan null
    } else {
      throw Exception('Failed to fetch quiz ID');
    }
  }
}
