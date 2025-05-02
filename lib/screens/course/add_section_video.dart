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
                  await Provider.of<SectionProvider>(
                    context,
                    listen: false,
                  ).updateSection(section.id, editController.text);
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
                  decoration: const InputDecoration(labelText: 'Durasi'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  setState(() => _isLoading = true);
                  await Provider.of<VideoProvider>(
                    context,
                    listen: false,
                  ).addVideo(
                    sectionId: sectionId,
                    title: titleController.text,
                    url: urlController.text,
                    duration: durationController.text,
                  );
                  await Provider.of<SectionProvider>(
                    context,
                    listen: false,
                  ).fetchSections(widget.courseId);
                  setState(() => _isLoading = false);
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

 void _deleteVideo(int videoId) async {
  setState(() => _isLoading = true);
  try {
    await Provider.of<VideoProvider>(context, listen: false).deleteVideo(videoId);
    await Provider.of<SectionProvider>(context, listen: false).fetchSections(widget.courseId);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error deleting video: $e')),
    );
  } finally {
    setState(() => _isLoading = false);
  }
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
                    child: const Text('Tambah Section'),
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
                                      section.id,
                                    );
                                    await sectionProvider.fetchSections(
                                      widget.courseId,
                                    );
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
                          ...videoProvider.videos
                              .where((video) => video.sectionId == section.id)
                              .map(
                                (video) => ListTile(
                                  title: Text(video.title),
                                  subtitle: Text('Durasi: ${video.duration}'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),
                                        onPressed:
                                            () => _showEditVideoModal(video),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () => _deleteVideo(video.id),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
    );
  }
}
