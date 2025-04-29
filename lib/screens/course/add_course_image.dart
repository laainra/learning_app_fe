import 'dart:io';
import 'package:finbedu/screens/course/add_section_video.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:finbedu/providers/course_provider.dart';

class UploadImageScreen extends StatefulWidget {
  final int courseId;

  const UploadImageScreen({Key? key, required this.courseId}) : super(key: key);

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih gambar terlebih dahulu')),
      );
      return;
    }

    final provider = Provider.of<CourseProvider>(context, listen: false);
    bool success = await provider.uploadCourseImage(widget.courseId, _selectedImage!);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gambar berhasil diunggah')),
      );
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => AddSectionScreen(courseId: widget.courseId)),
    );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal upload gambar')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Gambar Course')),
      body: Column(
        children: [
          InkWell(
            onTap: _pickImage,
            child: _selectedImage != null
                ? Image.file(_selectedImage!, height: 200)
                : Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.add_a_photo, size: 50),
                  ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _uploadImage,
            child: const Text('Upload dan Lanjut'),
          ),
        ],
      ),
    );
  }
}