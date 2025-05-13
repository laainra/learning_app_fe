import 'package:finbedu/models/quiz_question_model.dart';
import 'package:finbedu/services/quiz_service.dart';
import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  final int quizId;

  const QuizPage({super.key, required this.quizId});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestionIndex = 0;
  int? selectedAnswerId;
  Map<int, int> userAnswers = {}; // key: questionId, value: answerId

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A214C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Quiz", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        actions: const [
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Chip(
              label: Text("16:35", style: TextStyle(color: Colors.blue)),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<QuizQuestion>>(
        future: QuizService().fetchQuestions(widget.quizId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No questions available"));
          }

          final questions = snapshot.data!;
          final currentQuestion = questions[currentQuestionIndex];

          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${currentQuestionIndex + 1}. ${currentQuestion.question}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...currentQuestion.answers.map((answer) {
                            return RadioListTile<int>(
                              value: answer.id,
                              groupValue: userAnswers[currentQuestion.id],
                              onChanged: (value) {
                                setState(() {
                                  userAnswers[currentQuestion.id] = value!;
                                  selectedAnswerId = value;
                                });
                              },
                              title: Text(answer.answer),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              _NumberTabSelector(
                totalQuestions: questions.length,
                selectedQuestion: currentQuestionIndex + 1,
                onQuestionSelected: (index) {
                  setState(() {
                    currentQuestionIndex = index - 1;
                    selectedAnswerId = userAnswers[questions[index - 1].id];
                  });
                },
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    // Jika semua pertanyaan dijawab, lanjut ke hasil
                    if (userAnswers.length == questions.length) {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) => QuizResultPage(score: userAnswers.length * 10), // Skor dummy 10 per soal
                      //   ),
                      // );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please answer all questions"),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Submit Answers",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NumberTabSelector extends StatelessWidget {
  final int totalQuestions;
  final int selectedQuestion;
  final ValueChanged<int> onQuestionSelected;

  const _NumberTabSelector({
    required this.totalQuestions,
    required this.selectedQuestion,
    required this.onQuestionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final numbers = List.generate(totalQuestions, (i) => i + 1);
    return Wrap(
      spacing: 8,
      children:
          numbers.map((number) {
            final isSelected = number == selectedQuestion;
            return GestureDetector(
              onTap: () => onQuestionSelected(number),
              child: CircleAvatar(
                radius: 18,
                backgroundColor:
                    isSelected ? Colors.blue : Colors.grey.shade300,
                child: Text(
                  "$number",
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}
