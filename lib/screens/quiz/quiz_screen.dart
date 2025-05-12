import 'package:finbedu/models/quiz_model.dart';
import 'package:finbedu/models/quiz_question_model.dart';
import 'package:finbedu/services/quiz_service.dart';
import 'package:flutter/material.dart';

class QuizDetailPage extends StatelessWidget {
  final int sectionId; // Tambahkan parameter sectionId

  const QuizDetailPage({super.key, required this.sectionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A214C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Detail Quiz', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
        elevation: 0,
      ),
      body: FutureBuilder<List<Quiz>>(
        future: QuizService().fetchQuizzes(sectionId), // Ambil quiz berdasarkan sectionId
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No quizzes available"));
          }

          final quizzes = snapshot.data!;
          final quiz = quizzes.first; // Ambil quiz pertama (jika ada)

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
                child: Text(
                  quiz.section.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    Text("GET 100 Points", style: TextStyle(color: Colors.white70)),
                    Spacer(),
                    Icon(Icons.star, color: Colors.amber),
                    Text(" 4.8", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Brief explanation about this quiz",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      const _InfoRow(icon: Icons.list, text: "10 Question\n10 point for a correct answer"),
                      const _InfoRow(icon: Icons.access_time, text: "1 hour 15 min\nTotal duration of the quiz"),
                      const _InfoRow(icon: Icons.emoji_events, text: "Win 10 star\nAnswer all questions correctly"),
                      const SizedBox(height: 16),
                      const Text(
                        "Please read the text below carefully so you can understand it",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "• 10 point awarded for a correct answer and no marks for a incorrect answer\n"
                        "• Tap on options to select the correct answer\n"
                        "• Tap on the bookmark icon to save interesting questions\n"
                        "• Click submit if you are sure you want to complete all the quizzes",
                        style: TextStyle(height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(24),
                color: Colors.white,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuizPage(quizId: quiz.id), // Kirim quizId ke QuizPage
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text("Start Quiz"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A214C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    minimumSize: const Size.fromHeight(50),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 28),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
class QuizPage extends StatefulWidget {
  final int quizId; // Tambahkan parameter quizId

  const QuizPage({super.key, required this.quizId});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int? selectedAnswerId;
  int currentQuestionIndex = 0; // Tambahkan indeks pertanyaan saat ini

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A214C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Graphic Design Quiz", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        actions: const [
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Chip(label: Text("16:35", style: TextStyle(color: Colors.blue))),
          )
        ],
      ),
      body: FutureBuilder<List<QuizQuestion>>(
        future: QuizService().fetchQuestions(widget.quizId), // Ambil pertanyaan berdasarkan quizId
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
                              groupValue: selectedAnswerId,
                              onChanged: (value) {
                                setState(() {
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: _NumberTabSelector(
                  totalQuestions: questions.length,
                  selectedQuestion: currentQuestionIndex + 1,
                  onQuestionSelected: (selectedIndex) {
                    setState(() {
                      currentQuestionIndex = selectedIndex - 1;
                      selectedAnswerId = null; // Reset jawaban yang dipilih
                    });
                  },
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: numbers.map((number) {
        final isSelected = number == selectedQuestion;
        return GestureDetector(
          onTap: () => onQuestionSelected(number),
          child: CircleAvatar(
            radius: 16,
            backgroundColor: isSelected ? Colors.blue : Colors.grey.shade200,
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
class QuizResultPage extends StatelessWidget {
  const QuizResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFD3F1F7), Color(0xFFE7F9FB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Your Score",
              style: TextStyle(fontSize: 18, color: Colors.black45),
            ),
            const SizedBox(height: 8),
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blue,
              child: Text(
                "29/30",
                style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Congratulation",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 8),
            const Text(
              "Great job, Rumi Aktar! You Did It",
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text("Back To Course"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A214C),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
