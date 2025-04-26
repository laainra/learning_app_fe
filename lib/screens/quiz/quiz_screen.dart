import 'package:flutter/material.dart';

class QuizDetailPage extends StatelessWidget {
  const QuizDetailPage({super.key});

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
            child: Text(
              "Graphic Design Quiz",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
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
                  const Text("Brief explanation about this quiz", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  const _InfoRow(icon: Icons.list, text: "10 Question\n10 point for a correct answer"),
                  const _InfoRow(icon: Icons.access_time, text: "1 hour 15 min\nTotal duration of the quiz"),
                  const _InfoRow(icon: Icons.emoji_events, text: "Win 10 star\nAnswer all questions correctly"),
                  const SizedBox(height: 16),
                  const Text("Please read the text below carefully so you can understand it", style: TextStyle(fontWeight: FontWeight.bold)),
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
                Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizPage()));
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
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int selected = 3;

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
      body: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                const _NumberTabSelector(),
                const SizedBox(height: 24),
                const Text(
                  "What is the meaning of UI UX Design ?",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 24),
                ...List.generate(5, (i) {
                  final options = [
                    "User Interface and User Experience",
                    "User Interface and User Experience",
                    "User Interface and Using Experience",
                    "User Interface and User Experience",
                    "Using Interface and Using Experience",
                  ];
                  return RadioListTile<int>(
                    value: i,
                    groupValue: selected,
                    onChanged: (val) => setState(() => selected = val!),
                    title: Text(
                      options[i],
                      style: TextStyle(
                        color: selected == i ? Colors.blue : Colors.black87,
                        fontWeight: selected == i ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizResultPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.blue),
                    foregroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Submit Quiz"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NumberTabSelector extends StatelessWidget {
  const _NumberTabSelector();

  @override
  Widget build(BuildContext context) {
    final numbers = List.generate(10, (i) => i + 1);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: numbers.map((e) {
        bool isSelected = e == 10;
        return CircleAvatar(
          radius: 16,
          backgroundColor: isSelected ? Colors.blue : Colors.grey.shade200,
          child: Text(
            "$e",
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black54,
              fontWeight: FontWeight.bold,
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
