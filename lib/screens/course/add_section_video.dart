import 'package:finbedu/providers/quiz_provider.dart';
import 'package:finbedu/screens/course/video_player.dart';
import 'package:finbedu/screens/quiz/add_quiz.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finbedu/models/section_model.dart';
import 'package:finbedu/models/video_model.dart';
import 'package:finbedu/providers/section_provider.dart';
import 'package:finbedu/providers/video_provider.dart';

class AddSectionScreen extends StatefulWidget {
  final int courseId;
  const AddSectionScreen({Key? key, required this.courseId}) : super(key: key);

  @override
  State<AddSectionScreen> createState() => _AddSectionScreenState();
}

class _AddSectionScreenState extends State<AddSectionScreen> {
  final TextEditingController _sectionNameController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final sectionProvider = Provider.of<SectionProvider>(
      context,
      listen: false,
    );
    sectionProvider.fetchSections(widget.courseId);
  }

  void _addSection() async {
    if (_sectionNameController.text.isEmpty) return;

    setState(() => _isLoading = true);

    final sectionProvider = Provider.of<SectionProvider>(
      context,
      listen: false,
    );
    await sectionProvider.addSection(
      widget.courseId,
      _sectionNameController.text,
    );
    await sectionProvider.fetchSections(widget.courseId);
    _sectionNameController.clear();

    setState(() => _isLoading = false);
  }

  void _addQuizAndNavigate(int sectionId) async {
    setState(() => _isLoading = true);

    try {
      // Tambahkan quiz ke server
      final quizId = await Provider.of<QuizProvider>(
        context,
        listen: false,
      ).addQuiz(sectionId);

      // Navigasi ke halaman Add Quiz
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddQuizScreen(quizId: quizId)),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menambahkan quiz: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showVideoModal(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VideoPlayerScreen(videoUrl: url)),
    );
  }

  late SectionProvider _sectionProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sectionProvider = Provider.of<SectionProvider>(context, listen: false);
  }

  void _fetchSections() async {
    try {
      print('Mengambil ulang sections...');
      await _sectionProvider.fetchSections(widget.courseId);
      print('Sections berhasil diperbarui.');
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memperbarui sections: $e')));
    }
  }

  void _showEditSectionModal(Section section) {
    final TextEditingController editController = TextEditingController(
      text: section.name,
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Section'),
            content: TextField(controller: editController),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  setState(() => _isLoading = true);

                  try {
                    await Provider.of<SectionProvider>(
                      context,
                      listen: false,
                    ).updateSection(
                      widget.courseId,
                      section.id,
                      editController.text,
                    );
                    print('Section berhasil diperbarui.');

                    await Provider.of<SectionProvider>(
                      context,
                      listen: false,
                    ).fetchSections(widget.courseId);
                    print('Sections berhasil diperbarui.');
                  } catch (e) {
                    print('Error: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal memperbarui section: $e')),
                    );
                  } finally {
                    _sectionNameController.clear();
                    setState(() => _isLoading = false);
                  }
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
    );
  }

  void _showAddVideoModal(int sectionId) {
    final titleController = TextEditingController();
    final urlController = TextEditingController();
    final durationController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
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
                  decoration: const InputDecoration(
                    labelText: 'Durasi (hh:mm:ss)',
                    hintText: 'Contoh: 01:30:45',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  final title = titleController.text;
                  final url = urlController.text;
                  final duration = durationController.text;

                  final sectionIdToUse = sectionId;
                  Navigator.pop(context);

                  // Tunda eksekusi async sampai context stabil
                  Future.microtask(() async {
                    if (!mounted) return;
                    setState(() => _isLoading = true);
                    try {
                      print('Menambahkan video...');
                      await Provider.of<VideoProvider>(
                        context,
                        listen: false,
                      ).addVideo(
                        sectionId: sectionIdToUse,
                        title: title,
                        url: url,
                        duration: duration,
                      );
                      print('Video berhasil ditambahkan.');

                      if (!mounted) return;
                      print('Mengambil ulang sections...');
                      await Provider.of<SectionProvider>(
                        context,
                        listen: false,
                      ).fetchSections(widget.courseId);
                      print('Sections berhasil diperbarui.');
                    } catch (e) {
                      print('Error: $e');
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Gagal menambahkan video: $e'),
                          ),
                        );
                      }
                    } finally {
                      if (mounted) {
                        setState(() => _isLoading = false);
                      }
                    }
                  });
                },
                child: const Text('Tambah'),
              ),
            ],
          ),
    );
  }

  void _showEditVideoModal(Video video) {
    final titleController = TextEditingController(text: video.title);
    final urlController = TextEditingController(text: video.url);
    final durationController = TextEditingController(text: video.duration);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Video'),
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
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  setState(() => _isLoading = true);
                  await Provider.of<VideoProvider>(
                    context,
                    listen: false,
                  ).updateVideo(
                    video.id,
                    titleController.text,
                    urlController.text,
                    durationController.text,
                  );
                  await Provider.of<SectionProvider>(
                    context,
                    listen: false,
                  ).fetchSections(widget.courseId);
                  setState(() => _isLoading = false);
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
    );
  }

  void _deleteVideo(int sectionId, int videoId) {
    setState(() => _isLoading = true);

    final sectionProvider = Provider.of<SectionProvider>(
      context,
      listen: false,
    );

    final section = sectionProvider.sections.firstWhere(
      (s) => s.id == sectionId,
    );
    section.videos.removeWhere((video) => video.id == videoId);

    sectionProvider.notifyListeners();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final sectionProvider = Provider.of<SectionProvider>(context);
    final videoProvider = Provider.of<VideoProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Section & Video')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextField(
                    controller: _sectionNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Section',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _addSection,
                    child: const Text('Tambah Section' ,
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF202244),
                ),
                  ),
                  const SizedBox(height: 20),
                  ...sectionProvider.sections.map((section) {
                    return Card(
                      child: ExpansionTile(
                        title: Text(section.name),
                        onExpansionChanged: (expanded) async {
                          if (expanded) {
                            await videoProvider.fetchVideos(section.id);
                          }
                        },
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.quiz),
                                onPressed:
                                    () => _addQuizAndNavigate(section.id),
                                tooltip: 'Tambah Quiz',
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () => _showEditSectionModal(section),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder:
                                        (context) => AlertDialog(
                                          title: const Text('Hapus Section'),
                                          content: const Text(
                                            'Apakah Anda yakin ingin menghapus section ini?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(
                                                    context,
                                                    false,
                                                  ),
                                              child: const Text('Batal'),
                                            ),
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(
                                                    context,
                                                    true,
                                                  ),
                                              child: const Text('Hapus'),
                                            ),
                                          ],
                                        ),
                                  );

                                  if (confirm == true) {
                                    setState(() => _isLoading = true);
                                    await sectionProvider.deleteSection(
                                      widget.courseId,
                                      section.id,
                                    );
                                    // await sectionProvider.fetchSections(
                                    //   widget.courseId,
                                    // );
                                    setState(() => _isLoading = false);
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () => _showAddVideoModal(section.id),
                              ),
                            ],
                          ),
                          ...section.videos.map(
                            (video) => ListTile(
                              leading: IconButton(
                                icon: const Icon(
                                  Icons.play_circle_fill,
                                  color: Colors.blueAccent,
                                ),
                                onPressed: () => _showVideoModal(video.url),
                                tooltip: 'Preview Video',
                              ),
                              title: Text(video.title),
                              subtitle: Text('Durasi: ${video.duration}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => _showEditVideoModal(video),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed:
                                        () =>
                                            _deleteVideo(section.id, video.id),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
    );
  }
}
