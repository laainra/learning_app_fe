import 'dart:io';
import 'package:finbedu/screens/course/add_section_video.dart';
import 'package:finbedu/services/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

          // Tampilkan modal upload gambar
          _showUploadImageModal(courseId);
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

  void _showUploadImageModal(int courseId) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return AlertDialog(
              title: const Text('Upload Gambar'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tampilkan gambar yang dipilih
                  _selectedImage != null
                      ? Image.file(
                        _selectedImage!,
                        height: 150,
                        fit: BoxFit.cover,
                      )
                      : const Text('Belum ada gambar yang dipilih'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      await _pickImage();
                      // Trigger setState di modal agar gambar terupdate
                      setStateModal(() {});
                    },
                    child: const Text('Pilih Gambar dari Galeri'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      await _uploadImage(courseId);
                      Navigator.pop(context); // Tutup modal
                      // Navigasi ke halaman Section Video
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddSectionScreen(courseId: courseId),
                        ),
                      );
                    },
                    child: const Text('Upload Gambar'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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

  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage(int courseId) async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih gambar terlebih dahulu')),
      );
      return;
    }

    final success = await Provider.of<CourseProvider>(
      context,
      listen: false,
    ).uploadCourseImage(courseId, _selectedImage!);

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gambar berhasil diupload')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal mengupload gambar')));
    }
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
            if (widget.course != null)
              Row(
                children: [
                  if (widget.course!.image != null)
                    Expanded(
                      child: Column(
                        children: [
                          Image.network(
                            '${Constants.imgUrl}/${widget.course!.image}', // Tampilkan gambar jika sudah ada
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Gambar saat ini',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Expanded(
                      child: Text(
                        'Belum ada gambar',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (widget.course != null) {
                        _showUploadImageModal(
                          widget.course!.id!,
                        ); // Tampilkan modal upload gambar
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Simpan course terlebih dahulu'),
                          ),
                        );
                      }
                    },
                    child:
                        widget.course!.image != null
                            ? const Text('Edit Gambar')
                            : const Text('Upload Gambar'),
                  ),
                ],
              ),
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
            Text("Pilih Level"),
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
            Text(" Pilih Kategori"),
            Consumer<CategoryProvider>(
              builder: (context, categoryProvider, child) {
                return Column(
                  children: [
                    DropdownButton<int>(
                      hint: const Text('Pilih Kategori'),
                      value: _selectedCategoryId,
                      items: [
                        ...categoryProvider.categories.map(
                          (category) => DropdownMenuItem<int>(
                            value: category.id,
                            child: Text(category.name),
                          ),
                        ),
                        const DropdownMenuItem<int>(
                          value: -1,
                          child: Text(
                            '➕ Tambah Kategori',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                      onChanged: (selectedCategoryId) {
                        if (selectedCategoryId == -1) {
                          _showAddCategoryModal();
                        } else {
                          setState(() {
                            _selectedCategoryId = selectedCategoryId;
                          });
                        }
                      },
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
