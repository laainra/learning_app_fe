import 'package:flutter/material.dart';
import '../../widgets/input_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/CustomHeader.dart';
import '../../services/user_service.dart';

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

  Future<void> _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        dobController.text = "${picked.toLocal()}".split(' ')[0];
      });
  }

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
              label: '(+1) 724-848-1225',
              icon: Icons.flag,
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
            const SizedBox(height: 15),

            const SizedBox(height: 30),

            // Continue Button
            ActionButton(
              label: 'Continue',
              color: const Color(0xFF1D224F),
              onTap: () async {
                FocusScope.of(
                  context,
                ).unfocus(); // Menghilangkan fokus dari field input
                print("Continue button pressed");

                final userService = UserService();
                final name = nameController.text.trim();
                final email = emailController.text.trim();
                final dob = dobController.text.trim();
                final phone = phoneController.text.trim();

                // if (name.isEmpty || email.isEmpty) {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(
                //       content: Text("Name and email are required"),
                //     ),
                //   );
                //   return;
                // }

                Map<String, dynamic> updatedData = {};

                if (name.isNotEmpty) updatedData['name'] = name;
                if (email.isNotEmpty) updatedData['email'] = email;
                if (dob.isNotEmpty) updatedData['dob'] = dob;
                if (phone.isNotEmpty) updatedData['phone'] = phone;
                if (selectedGender != null)
                  updatedData['gender'] = selectedGender;

                if (updatedData.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("No data to update")),
                  );
                  return;
                }

                try {
                  final success = await userService.updateProfile(updatedData);

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Profile updated successfully"),
                      ),
                    );
                    Navigator.pop(context);
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Failed to update profile: ${e.toString()}",
                      ),
                    ),
                  );
                }
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
