import 'package:finbedu/screens/course/add_section_video.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:finbedu/models/course_model.dart';
import 'package:finbedu/providers/category_providers.dart';
import 'package:finbedu/providers/course_provider.dart';
import 'package:finbedu/widgets/custom_button.dart';
import 'package:finbedu/widgets/input_field.dart';

class AddCourseScreen extends StatefulWidget {
  final Course? course;

  const AddCourseScreen({super.key, this.course});
  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _levelController = TextEditingController();

  String _selectedLevel = 'beginner'; // Default value for the level
  int? _selectedCategoryId; // Variable to store selected category ID

  bool mediaFullAccess = false;
  bool audioBook = false;
  bool lifetimeAccess = false;
  bool certificate = false;
  @override
  void initState() {
    super.initState();
    _categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    _categoryProvider
        .fetchCategories()
        .then((_) {
          print('Categories fetched successfully');
        })
        .catchError((error) {
          print('Error fetching categories: $error');
        });
    // Jika ada data course, isi form dengan data tersebut
    if (widget.course != null) {
      final course = widget.course!;
      _nameController.text = course.name;
      _descController.text = course.desc;
      _priceController.text = course.price;
      _selectedLevel = course.level;
      _selectedCategoryId = course.categoryId;
      mediaFullAccess = course.mediaFullAccess;
      audioBook = course.audioBook;
      lifetimeAccess = course.lifetimeAccess;
      certificate = course.certificate;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _levelController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
  final provider = Provider.of<CourseProvider>(context, listen: false);

  final course = Course(
    id: widget.course?.id,
    name: _nameController.text,
    desc: _descController.text,
    price: _priceController.text,
    level: _selectedLevel,
    categoryId: _selectedCategoryId,
    mediaFullAccess: mediaFullAccess,
    audioBook: audioBook,
    lifetimeAccess: lifetimeAccess,
    certificate: certificate,
  );

  try {
    if (widget.course == null) {
      // Tambah course baru
      int? courseId = await provider.createCourse(course);
      if (courseId != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Course berhasil dibuat')),
        );
        // Navigasi ke halaman Section Video
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => AddSectionScreen(courseId: courseId),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Gagal membuat course')));
      }
    } else {
      // Update course yang ada
      bool success = await provider.updateCourse(course);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Course berhasil diperbarui')),
        );
        // Navigasi ke halaman Section Video
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => AddSectionScreen(courseId: course.id!),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memperbarui course')),
        );
      }
    }
  } catch (e) {
    print('Error: $e');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Terjadi kesalahan')));
  }
}

  final _categoryController = TextEditingController();
  late CategoryProvider _categoryProvider;

  void _showAddCategoryModal() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Kategori'),
          content: TextField(
            controller: _categoryController,
            decoration: const InputDecoration(hintText: 'Nama Kategori'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_categoryController.text.isNotEmpty) {
                  _categoryProvider.addCategory(_categoryController.text);
                  _categoryController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Simpan'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CourseProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course == null ? 'Tambah Course' : 'Edit Course'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Nama Course',
              icon: Icons.book,
              controller: _nameController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Deskripsi',
              icon: Icons.description,
              controller: _descController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Harga',
              icon: Icons.money,
              controller: _priceController,
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: _selectedLevel,
              items: const [
                DropdownMenuItem(value: 'beginner', child: Text('Beginner')),
                DropdownMenuItem(
                  value: 'intermediate',
                  child: Text('Intermediate'),
                ),
                DropdownMenuItem(value: 'advanced', child: Text('Advanced')),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLevel = newValue!;
                });
              },
              isExpanded: true,
              hint: const Text('Pilih Level'),
            ),
            const SizedBox(height: 16),
            Consumer<CategoryProvider>(
              builder: (context, categoryProvider, child) {
                return Column(
                  children: [
                    DropdownButton<int>(
                      hint: const Text('Pilih Kategori'),
                      value: _selectedCategoryId,
                      items:
                          categoryProvider.categories
                              .map(
                                (category) => DropdownMenuItem<int>(
                                  value: category.id,
                                  child: Text(category.name),
                                ),
                              )
                              .toList(),
                      onChanged: (selectedCategoryId) {
                        setState(() {
                          _selectedCategoryId = selectedCategoryId;
                        });
                      },
                    ),
                    TextButton(
                      onPressed: _showAddCategoryModal,
                      child: const Text('Tambah Kategori'),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Media Full Access'),
              value: mediaFullAccess,
              onChanged: (bool? value) {
                setState(() {
                  mediaFullAccess = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Audio Book'),
              value: audioBook,
              onChanged: (bool? value) {
                setState(() {
                  audioBook = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Lifetime Access'),
              value: lifetimeAccess,
              onChanged: (bool? value) {
                setState(() {
                  lifetimeAccess = value!;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Certificate'),
              value: certificate,
              onChanged: (bool? value) {
                setState(() {
                  certificate = value!;
                });
              },
            ),
            const SizedBox(height: 24),
            provider.isLoading
                ? const CircularProgressIndicator()
                : ActionButton(
                  label:
                      widget.course == null ? 'Tambah Course' : 'Edit Course',
                  color: Colors.blue,
                  width: double.infinity,
                  height: 50,
                  onTap: _submit,
                ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
