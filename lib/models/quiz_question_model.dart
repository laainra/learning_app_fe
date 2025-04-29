class QuizQuestion {
  final int id;
  final String question;
  final int quizId;

  QuizQuestion({required this.id, required this.question, required this.quizId});

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'],
      question: json['question'],
      quizId: json['quiz_id'],
    );
  }
}
