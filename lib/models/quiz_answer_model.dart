class QuizAnswer {
  final int id;
  final String answer;
  final bool status; // true if correct

  QuizAnswer({required this.id, required this.answer, required this.status});

  factory QuizAnswer.fromJson(Map<String, dynamic> json) {
    return QuizAnswer(
      id: json['id'],
      answer: json['answer'],
      status: json['status'],
    );
  }
}
