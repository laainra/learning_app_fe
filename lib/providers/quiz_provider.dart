import 'package:finbedu/models/quiz_model.dart';
import 'package:finbedu/models/quiz_question_model.dart';
import 'package:finbedu/models/quiz_answer_model.dart';
import 'package:finbedu/services/quiz_service.dart';
import 'package:flutter/material.dart';

class QuizProvider extends ChangeNotifier {
  final QuizService _quizService = QuizService();
  List<Quiz> _quizzes = [];
  List<QuizQuestion> _questions = [];
  List<QuizAnswer> _answers = [];

  List<Quiz> get quizzes => _quizzes;
  List<QuizQuestion> get questions => _questions;
  List<QuizAnswer> get answers => _answers;

  List<QuizQuestion> get quizQuestions => _questions; // Tambahkan getter ini
  bool isLoading = false;

  Quiz? _quizDetails;

Quiz? get quizDetails => _quizDetails;

  
Future<int> addQuiz(int sectionId) async {
  return await _quizService.addQuiz(sectionId);
}

  Future<void> loadQuizzes(int sectionId) async {
    try {
      _quizzes = await _quizService.fetchQuizzes(sectionId);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load quizzes');
    }
  }
  Future<void> editQuestionWithAnswers(
  int quizId,
  int questionId,
  String question,
  List<Map<String, dynamic>> answers,
) async {
  try {
    await _quizService.editQuestionWithAnswers(quizId, questionId, question, answers);
    await loadQuizDetails(quizId); // Refresh data quiz
  } catch (e) {
    throw Exception('Failed to edit question: $e');
  }
}

  Future<void> loadQuizDetails(int quizId) async {
  try {
    _quizDetails = await _quizService.fetchQuizDetails(quizId);
    notifyListeners();
  } catch (e) {
    throw Exception('Failed to load quiz details: $e');
  }
}

  Future<void> loadQuizAnswers(int questionId) async {
    try {
      final answers = await _quizService.getAnswersByQuestionId(questionId);
      _answers = answers; // Gunakan _answers yang sudah didefinisikan
      notifyListeners();
    } catch (e) {
      print('Error loading quiz answers: $e');
      throw Exception('Failed to load quiz answers');
    }
  }

 Future<void> fetchQuestions(int sectionId) async {
    try {
      _questions = await _quizService.fetchQuestions(sectionId);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch questions');
    }
  }

  Future<void> loadQuizQuestions(int sectionId) async {
  try {
   
    isLoading = true;
    notifyListeners();
    _questions = await _quizService.fetchQuestions(sectionId);
        isLoading = false;
    notifyListeners();
  } catch (e) {
    print('Error loading quiz questions: $e');
        isLoading = false;
    notifyListeners();
  }
}

  Future<void> fetchAnswers(int questionId) async {
    try {
      _answers = await _quizService.fetchAnswers(questionId);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch answers');
    }
  }

  Future<void> createQuiz(
    int sectionId,
    String question,
    List<String> answers,
    int correctAnswerIndex,
  ) async {
    try {
      final questionId = await createQuizQuestion(sectionId, question);

      for (int i = 0; i < answers.length; i++) {
        bool isCorrect = i == correctAnswerIndex;
        await createQuizAnswer(questionId, answers[i], isCorrect);
      }

      await loadQuizzes(sectionId);
    } catch (e) {
      throw Exception('Failed to create quiz');
    }
  }

  Future<int> createQuizQuestion(int quizId, String question) async {
    try {
      return await _quizService.addQuestion(quizId, question);
    } catch (e) {
      throw Exception('Failed to create quiz question');
    }
  }

  Future<void> createQuizAnswer(int questionId, String answer, bool isCorrect) async {
    try {
      await _quizService.addAnswer(questionId, answer, isCorrect);
    } catch (e) {
      throw Exception('Failed to create quiz answer');
    }
  }

  Future<void> updateQuestion(int questionId, String question) async {
    await _quizService.updateQuestion(questionId, question);
    notifyListeners();
  }

  Future<void> deleteQuestion(int quizId, int questionId) async {
  try {
    await _quizService.deleteQuestion(questionId);
    await loadQuizDetails(quizId); // Refresh data quiz
  } catch (e) {
    throw Exception('Failed to delete question: $e');
  }
}

  Future<void> updateAnswer(int answerId, String answer) async {
    await _quizService.updateAnswer(answerId, answer);
    notifyListeners();
  }

  Future<void> deleteAnswer(int answerId) async {
    await _quizService.deleteAnswer(answerId);
    notifyListeners();
  }

  Future<void> addQuestionWithAnswers(
  int quizId,
  String question,
  List<Map<String, dynamic>> answers,
) async {
  try {
    await _quizService.addQuestionWithAnswers(quizId, question, answers);
    // await loadQuizQuestions(quizId); // Refresh pertanyaan setelah menambahkan
  } catch (e) {
    throw Exception('Failed to add question with answers');
  }
}

}