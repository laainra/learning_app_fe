class QuizAnswer {
  final int id;
  final int quizQuestionId;
  final String answer;
  final bool status;

  QuizAnswer({
    required this.id,
    required this.quizQuestionId,
    required this.answer,
    required this.status,
  });

  factory QuizAnswer.fromJson(Map<String, dynamic> json) {
    return QuizAnswer(
      id: json['id'],
      quizQuestionId: json['quiz_question_id'],
      answer: json['answer'],
      status: json['status'] == 1, // Convert 1/0 to true/false
    );
  }
}