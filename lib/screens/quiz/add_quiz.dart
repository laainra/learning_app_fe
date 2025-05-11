import 'package:finbedu/models/quiz_question_model.dart';
import 'package:finbedu/models/quiz_answer_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finbedu/providers/quiz_provider.dart';
class AddQuizScreen extends StatefulWidget {
  final int quizId;

  const AddQuizScreen({Key? key, required this.quizId}) : super(key: key);

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

  void _addQuestion() async {
    final question = _questionController.text.trim();
    final answers = _answerControllers
        .asMap()
        .entries
        .map((entry) => {
              'answer': entry.value.text.trim(),
              'status': entry.key == _correctAnswerIndex,
            })
        .toList();

    try {
      await Provider.of<QuizProvider>(
        context,
        listen: false,
      ).addQuestionWithAnswers(widget.quizId, question, answers);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pertanyaan berhasil ditambahkan')),
      );

      // Reset input
      _questionController.clear();
      for (var controller in _answerControllers) {
        controller.clear();
      }
      setState(() => _correctAnswerIndex = 0);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan pertanyaan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Pertanyaan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                    onChanged: (value) {
                      setState(() {
                        _correctAnswerIndex = value!;
                      });
                    },
                  ),
                ],
              );
            }),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addQuestion,
              child: const Text('Tambah Pertanyaan'),
            ),
          ],
        ),
      ),
    );
  }
}