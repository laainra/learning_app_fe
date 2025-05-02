import 'package:finbedu/models/quiz_question_model.dart';
import 'package:finbedu/models/quiz_answer_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finbedu/providers/quiz_provider.dart';

class AddQuizScreen extends StatefulWidget {
  final int sectionId;

  const AddQuizScreen({
    Key? key,
    required this.sectionId,
  }) : super(key: key);

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
          content: SingleChildScrollView(
            child: Column(
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
                        onChanged: (value) {
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
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final provider = Provider.of<QuizProvider>(context, listen: false);

                List<String> answers = _answerControllers
                    .map((controller) => controller.text)
                    .toList();

                await provider.createQuiz(
                  widget.sectionId,
                  _questionController.text,
                  answers,
                  _correctAnswerIndex,
                );

                await provider.loadQuizQuestions(widget.sectionId); // Perbaikan: gunakan sectionId
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showEditQuestionModal(QuizQuestion question) {
    final questionController = TextEditingController(text: question.question);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Pertanyaan'),
          content: TextField(
            controller: questionController,
            decoration: const InputDecoration(labelText: 'Pertanyaan'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final provider = Provider.of<QuizProvider>(context, listen: false);

                await provider.updateQuestion(question.id, questionController.text);
                await provider.loadQuizQuestions(widget.sectionId); // Perbaikan: gunakan sectionId
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showEditAnswerModal(QuizAnswer answer, int questionId) {
    final answerController = TextEditingController(text: answer.answer);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Jawaban'),
          content: TextField(
            controller: answerController,
            decoration: const InputDecoration(labelText: 'Jawaban'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final provider = Provider.of<QuizProvider>(context, listen: false);

                await provider.updateAnswer(answer.id, answerController.text);
                await provider.loadQuizAnswers(questionId); // Perbaikan: gunakan questionId
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
        padding: const EdgeInsets.all(16),
        children: [
          ElevatedButton(
            onPressed: _showAddQuizModal,
            child: const Text('Tambah Quiz'),
          ),
          const SizedBox(height: 16),
          ...provider.quizQuestions.map((question) {
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ExpansionTile(
                title: Text(question.question),
                children: [
                  ...question.answers.map((answer) {
                    return ListTile(
                      title: Text(answer.answer),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showEditAnswerModal(answer, question.id),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Hapus Jawaban'),
                                  content: const Text('Yakin ingin menghapus jawaban ini?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: const Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: const Text('Hapus'),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                await provider.deleteAnswer(answer.id);
                                await provider.loadQuizAnswers(question.id); // Perbaikan: gunakan question.id
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  }),
                  ButtonBar(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showEditQuestionModal(question),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Hapus Pertanyaan'),
                              content: const Text('Yakin ingin menghapus pertanyaan ini?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Hapus'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await provider.deleteQuestion(question.id);
                            await provider.loadQuizQuestions(widget.sectionId); // Perbaikan: gunakan sectionId
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}