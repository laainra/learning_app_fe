import 'package:finbedu/providers/section_provider.dart';
import 'package:finbedu/providers/video_provider.dart';
import 'package:finbedu/screens/quiz/add_quiz.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class AddSectionScreen extends StatefulWidget {
  final int courseId;

  const AddSectionScreen({Key? key, required this.courseId}) : super(key: key);

  @override
  State<AddSectionScreen> createState() => _AddSectionScreenState();
}

class _AddSectionScreenState extends State<AddSectionScreen> {
  final TextEditingController _sectionNameController = TextEditingController();
  late SectionProvider _sectionProvider;
  late VideoProvider _videoProvider;

  @override
  void initState() {
    super.initState();
    _sectionProvider = Provider.of<SectionProvider>(context, listen: false);
    _videoProvider = Provider.of<VideoProvider>(context, listen: false);

    _sectionProvider.fetchSections(widget.courseId);
  }

  void _showAddVideoModal(int sectionId) {
    final titleController = TextEditingController();
    final urlController = TextEditingController();
    final durationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Video'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Judul Video'),
              ),
              TextField(
                controller: urlController,
                decoration: const InputDecoration(labelText: 'URL Video'),
              ),
              TextField(
                controller: durationController,
                decoration: const InputDecoration(labelText: 'Durasi'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _videoProvider.addVideo(
                  sectionId: sectionId,
                  title: titleController.text,
                  url: urlController.text,
                  duration: durationController.text,
                );
                Navigator.pop(context);
              },
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  void _addSection() async {
    if (_sectionNameController.text.isNotEmpty) {
      await _sectionProvider.addSection(
        widget.courseId,
        _sectionNameController.text,
      );
      _sectionNameController.clear();
      await _sectionProvider.fetchSections(
        widget.courseId,
      ); // Refresh data sections
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Section & Video')),
      body: Consumer<SectionProvider>(
        builder: (context, provider, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(
                controller: _sectionNameController,
                decoration: const InputDecoration(labelText: 'Nama Section'),
              ),
              ElevatedButton(
                onPressed: _addSection,
                child: const Text('Tambah Section'),
              ),
              const SizedBox(height: 20),
              ...provider.sections.map((section) {
                return Card(
                  child: ExpansionTile(
                    title: Text(section.name),
                    children: [
                      ...section.videos.map(
                        (video) => ListTile(
                          title: Text(video.title),
                          subtitle: Text('Durasi: ${video.duration}'),
                        ),
                      ),
                      TextButton(
                        onPressed: () => _showAddVideoModal(section.id),
                        child: const Text('Tambah Video'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Tambahkan logika untuk menambahkan quiz
                          print('Tambah Quiz untuk Section ID: ${section.id}');
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => AddQuizScreen(sectionId: section.id),
                            ),
                          );
                        },
                        child: const Text('Tambah Quiz'),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}
