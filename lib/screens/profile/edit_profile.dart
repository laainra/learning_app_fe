import 'package:flutter/material.dart';
import '../../widgets/input_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/CustomHeader.dart';

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
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomHeader(title: "Fill Your Profile"),
      backgroundColor: const Color(0xFFF5F8FE),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const SizedBox(height: 20),

            // Profile Picture
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  const CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 50, color: Colors.grey),
                  ),
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.green,
                    child: Icon(Icons.edit, size: 15, color: Colors.white),
                  ),
                ],
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
            CustomTextField(
              label: 'Date of Birth',
              icon: Icons.calendar_today,
              controller: dobController,
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
              label: '(+1) 724-848-1225',
              icon: Icons.flag,
              controller: phoneController,
            ),
            const SizedBox(height: 15),

            // Gender Dropdown
            DropdownButtonFormField<String>(
              value: selectedGender,
              items: ['Male', 'Female']
                  .map((gender) => DropdownMenuItem(
                        value: gender,
                        child: Text(gender),
                      ))
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
            const SizedBox(height: 15),

            // Role Dropdown
            DropdownButtonFormField<String>(
              value: selectedRole,
              items: ['Student', 'Intern', 'Staff']
                  .map((role) => DropdownMenuItem(
                        value: role,
                        child: Text(role),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => selectedRole = value),
              decoration: InputDecoration(
                labelText: 'Role',
                prefixIcon: const Icon(Icons.badge_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Continue Button
            ActionButton(
              label: 'Continue',
              color: const Color(0xFF1D224F),
              onTap: () {
                // Aksi saat tombol ditekan
              },
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
