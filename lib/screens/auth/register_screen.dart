import 'package:finbedu/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../../widgets/input_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/button_icon_circle.dart';
import '../../routes/app_routes.dart' as route;

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService authService = AuthService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  String? selectedRole; // Variable to hold the selected role

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F7FF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo + Title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white24,
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/logo.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'FINB',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w300,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 30,
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'EDU',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 30,
                                        color: Color.fromARGB(
                                          255,
                                          106,
                                          218,
                                          255,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Text(
                                "LEARN FROM EVERYWHERE",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 60),

                      const Text(
                        "Getting Started.!",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Create an Account to Continue your all Courses",
                      ),
                      const SizedBox(height: 24),

                      CustomTextField(
                        label: "Name",
                        icon: Icons.person,
                        controller: nameController,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: "Email",
                        icon: Icons.email,
                        controller: emailController,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        isPassword: true,
                        label: "Password",
                        icon: Icons.lock,
                        controller: passwordController,
                      ),
                      const SizedBox(height: 16),

                      // Dropdown for selecting role
                      DropdownButtonFormField<String>(
                        value: selectedRole,
                        hint: const Text("Select Role"),
                        items: [
                          DropdownMenuItem(
                            value: "mentor",
                            child: Text("Mentor"),
                          ),
                          DropdownMenuItem(
                            value: "student",
                            child: Text("Student"),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedRole = value;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Role",
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),

                      const SizedBox(height: 12),

                      ActionButton(
                        label: "Register",
                        onTap: () async {
                          final name = nameController.text.trim();
                          final email = emailController.text.trim();
                          final password = passwordController.text.trim();

                          try {
                            final success = await authService.register(
                              name,
                              email,
                              password,
                              selectedRole // Pass the selected role
                            );

                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Registration successful!"),
                                ),
                              );
                              Navigator.pushNamed(context, route.login);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Registration failed! Please try again.",
                                  ),
                                ),
                              );
                            }
                          } catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Registration failed: $error"),
                              ),
                            );
                          }
                        },
                        color: const Color(0xFF202244),
                        height: 60,
                        width: double.infinity,
                      ),

                      const SizedBox(height: 12),

                      const Center(child: Text("Or Continue With")),
                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleIconButton(
                            icon: Icons.g_mobiledata,
                            bgColor: Colors.white,
                            onPressed: () {},
                          ),
                          const SizedBox(width: 20),
                          CircleIconButton(
                            icon: Icons.apple,
                            bgColor: Colors.white,
                            onPressed: () {},
                          ),
                        ],
                      ),

                      const Spacer(),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an Account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, route.login);
                            },
                            child: const Text("SIGN IN"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}