import 'package:finbedu/providers/user_provider.dart';
import 'package:finbedu/services/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/input_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/CustomHeader.dart';
import '../../services/user_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  String? selectedGender;
  String? userImageUrl;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    nameController.dispose();
    dobController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      await userProvider.fetchProfile();
      final user = userProvider.user;

      if (user != null) {
        setState(() {
          nameController.text = user.name ?? '';
          dobController.text = user.dob ?? '';
          emailController.text = user.email ?? '';
          phoneController.text = user.noTelp ?? '';
          selectedGender = user.gender;
          userImageUrl = user.photo;
        });
      }
    } catch (e) {
      print('Error loading profile: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to load profile')));
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(dobController.text) ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        dobController.text = picked.toIso8601String().split('T').first;
      });
    }
  }

  Future<void> _saveProfile() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      await userProvider.updateProfile(
        name: nameController.text.trim(),
        dob: dobController.text.trim(),
        email: emailController.text.trim(),
        noTelp: phoneController.text.trim(),
        gender: selectedGender,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      print('Error saving profile: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to update profile')));
    }
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

  Future<void> _uploadImage(int userId) async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih gambar terlebih dahulu')),
      );
      return;
    }

    try {
      bool success = await Provider.of<UserProvider>(
        context,
        listen: false,
      ).uploadUserImage(userId, _selectedImage!);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gambar berhasil diupload')),
        );
      }
    } catch (e) {
      // Menampilkan pesan error dari Exception
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  void _showUploadImageModal(int userId) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return AlertDialog(
              title: const Text('Upload Photo Profile'),
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
                    child: const Text(
                      'Pilih Gambar dari Galeri',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF202244),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      await _uploadImage(userId);
                      Navigator.pop(context); // Tutup modal
                      // Navigasi ke halaman Section Video
                    },
                    child: const Text(
                      'Upload Gambar',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF202244),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomHeader(title: "Edit Profile"),
      backgroundColor: const Color(0xFFF5F8FE),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            // Profile Picture
            GestureDetector(
              onTap: () {
                final userId =
                    Provider.of<UserProvider>(context, listen: false).user!.id;
                _showUploadImageModal(userId!);
              },
              child: Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    ClipOval(
                      child:
                          (userImageUrl ?? '').isNotEmpty
                              ? Image.network(
                                '${Constants.imgUrl}/$userImageUrl',
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 90,
                                    height: 90,
                                    color: Colors.white,
                                    child: const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              )
                              : Container(
                                width: 90,
                                height: 90,
                                color: Colors.white,
                                child: const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              ),
                    ),
                    const CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.green,
                      child: Icon(Icons.edit, size: 15, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Name
            CustomTextField(
              label: 'Full Name',
              icon: Icons.person,
              controller: nameController,
            ),
            const SizedBox(height: 15),

            // Date of Birth
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: CustomTextField(
                  label: 'Date of Birth',
                  icon: Icons.calendar_today,
                  controller: dobController,
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Email
            CustomTextField(
              label: 'Email',
              icon: Icons.email,
              controller: emailController,
            ),
            const SizedBox(height: 15),

            // Phone Number
            CustomTextField(
              label: 'Phone Number',
              icon: Icons.phone,
              controller: phoneController,
            ),
            const SizedBox(height: 15),

            // Gender Dropdown
            DropdownButtonFormField<String>(
              value: selectedGender,
              items:
                  ['male', 'female']
                      .map(
                        (gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ),
                      )
                      .toList(),
              onChanged: (value) => setState(() => selectedGender = value),
              decoration: InputDecoration(
                labelText: 'Gender',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Save Button
            ActionButton(
              label: 'Save',
              color: const Color(0xFF1D224F),
              onTap: _saveProfile,
              width: double.infinity,
              height: 55,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
