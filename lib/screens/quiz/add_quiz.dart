import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finbedu/providers/quiz_provider.dart';

class AddQuizScreen extends StatefulWidget {
  final int sectionId;

  const AddQuizScreen({Key? key, required this.sectionId}) : super(key: key);

  @override
  State<AddQuizScreen> createState() => _AddQuizScreenState();
}

class _AddQuizScreenState extends State<AddQuizScreen> {
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _answerControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  int _correctAnswerIndex = 0;

  void _showAddQuizModal() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Quiz'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _questionController,
                decoration: const InputDecoration(labelText: 'Pertanyaan'),
              ),
              const SizedBox(height: 16),
              ...List.generate(4, (index) {
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _answerControllers[index],
                        decoration: InputDecoration(
                          labelText: 'Jawaban ${index + 1}',
                        ),
                      ),
                    ),
                    Radio<int>(
                      value: index,
                      groupValue: _correctAnswerIndex,
                      onChanged: (int? value) {
                        setState(() {
                          _correctAnswerIndex = value!;
                        });
                      },
                    ),
                  ],
                );
              }),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final provider = Provider.of<QuizProvider>(
                  context,
                  listen: false,
                );

                // Collecting the answers
                List<String> answers =
                    _answerControllers
                        .map((controller) => controller.text)
                        .toList();

                // Ensure correct number of arguments being passed
                await provider.createQuiz(
                  widget.sectionId,
                  _questionController.text,
                  answers,
                  _correctAnswerIndex,
                );

                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuizProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Quiz')),
      body: ListView(
        children: [
          ElevatedButton(
            onPressed: _showAddQuizModal,
            child: const Text('Tambah Quiz'),
          ),
          ...provider.quizzes.map((quiz) {
            return ListTile(
              title: Text('Quiz ${quiz.id}'),
              subtitle: Text('Section: ${quiz.sectionName}'),
            );
          }).toList(),
        ],
      ),
    );
  }
}

 // dari halmana section nanti tambahkan ada button add quiz lalu menuju ek halaman ini yaitu list quiz dengan modal add quiz nanti ke server add quiz dengan isinya input question lalu add jawabannya berupa 4 jawaban dengan 1 jawaban benar dengan checkbox atau apapun untuk menandai jika jawban benar  
