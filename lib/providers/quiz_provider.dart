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

  Future<void> loadQuizzes(int sectionId) async {
    try {
      _quizzes = await _quizService.fetchQuizzes(sectionId);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load quizzes');
    }
  }

  Future<void> fetchQuestions(int quizId) async {
    try {
      _questions = await _quizService.fetchQuestions(quizId);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch questions');
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

  // New method to create a quiz with a question and answers
  Future<void> createQuiz(int sectionId, String question, List<String> answers, int correctAnswerIndex) async {
    try {
      // Create the question first
      final questionId = await createQuizQuestion(sectionId, question);

      // Create the answers associated with the question
      for (int i = 0; i < answers.length; i++) {
        bool isCorrect = i == correctAnswerIndex;
        await createQuizAnswer(questionId, answers[i], isCorrect);
      }
      // After adding the quiz, you can optionally refresh the quizzes list
      await loadQuizzes(sectionId);
    } catch (e) {
      throw Exception('Failed to create quiz');
    }
  }

  // Existing methods for creating quiz questions and answers
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
}
