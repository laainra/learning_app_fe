import 'package:finbedu/models/quiz_question_model.dart';
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
  int? _editingQuestionId;

  @override
  void initState() {
    super.initState();
    _loadQuizDetails();
  }

  Future<void> _loadQuizDetails() async {
    try {
      await Provider.of<QuizProvider>(
        context,
        listen: false,
      ).loadQuizDetails(widget.quizId);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat detail quiz: $e')));
    }
  }

  void _showFormModal({QuizQuestion? question}) {
    if (question != null) {
      _loadQuestionToForm(question);
    } else {
      _questionController.clear();
      for (var c in _answerControllers) c.clear();
      _correctAnswerIndex = 0;
      _editingQuestionId = null;
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return AlertDialog(
              scrollable: true,
              title: Text(
                _editingQuestionId == null
                    ? 'Tambah Pertanyaan'
                    : 'Edit Pertanyaan',
              ),
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
                          onChanged: (value) {
                            setModalState(() {
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
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    _addQuestion();
                  },
                  child: Text(_editingQuestionId == null ? 'Tambah' : 'Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _addQuestion() async {
    final question = _questionController.text.trim();
    final answers =
        _answerControllers.asMap().entries.map((entry) {
          return {
            'answer': entry.value.text.trim(),
            'status': entry.key == _correctAnswerIndex,
          };
        }).toList();

    try {
      if (_editingQuestionId == null) {
        await Provider.of<QuizProvider>(
          context,
          listen: false,
        ).addQuestionWithAnswers(widget.quizId, question, answers);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pertanyaan berhasil ditambahkan')),
        );
      } else {
        await Provider.of<QuizProvider>(
          context,
          listen: false,
        ).editQuestionWithAnswers(
          widget.quizId,
          _editingQuestionId!,
          question,
          answers,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pertanyaan berhasil diperbarui')),
        );
        _editingQuestionId = null;
      }

      await _loadQuizDetails();

      // Reset form
      _questionController.clear();
      for (var controller in _answerControllers) {
        controller.clear();
      }
      setState(() => _correctAnswerIndex = 0);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan pertanyaan: $e')));
    }
  }

  void _loadQuestionToForm(QuizQuestion question) {
    _questionController.text = question.question;
    for (int i = 0; i < question.answers.length; i++) {
      _answerControllers[i].text = question.answers[i].answer;
      if (question.answers[i].status) {
        _correctAnswerIndex = i;
      }
    }
    _editingQuestionId = question.id;
  }

  void _deleteQuestion(int questionId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Konfirmasi'),
            content: const Text(
              'Apakah Anda yakin ingin menghapus pertanyaan ini?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Hapus'),
              ),
            ],
          ),
    );

    if (confirm == true) {
      try {
        await Provider.of<QuizProvider>(
          context,
          listen: false,
        ).deleteQuestion(widget.quizId, questionId);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pertanyaan berhasil dihapus')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghapus pertanyaan: ${e.toString()}'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            quizProvider.quizDetails == null
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                  itemCount: quizProvider.quizDetails!.questions.length,
                  itemBuilder: (context, index) {
                    final question = quizProvider.quizDetails!.questions[index];
                    return Card(
                      child: ExpansionTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text('${index + 1}. ${question.question}'),
                            ),
                            Row(
                              children: [
                                // IconButton(
                                //   icon: const Icon(
                                //     Icons.edit,
                                //     color: Colors.blue,
                                //   ),
                                //   onPressed:
                                //       () => _showFormModal(question: question),
                                // ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _deleteQuestion(question.id),
                                ),
                              ],
                            ),
                          ],
                        ),
                        children:
                            question.answers.map((answer) {
                              return ListTile(
                                title: Text(
                                  ' ${answer.status ? "(true)" : ""}${answer.answer}',
                                ),
                              );
                            }).toList(),
                      ),
                    );
                  },
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormModal(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
