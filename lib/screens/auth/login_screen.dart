import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import '../../widgets/input_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/button_icon_circle.dart';
import '../../routes/app_routes.dart' as route;
import '../../providers/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final AuthService authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F7FF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
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
                                        color: Color.fromARGB(255, 106, 218, 255),
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
                        "Let’s Sign In.!",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text("Login to Your Account to Continue your Courses"),
                      const SizedBox(height: 24),

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

                      Row(
                        children: [
                          Checkbox(value: false, onChanged: (val) {}),
                          const Text("Remember Me"),
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            child: const Text("Forgot Password?"),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      ActionButton(
                        label: "Sign In",
                        onTap: () async {
                          final email = emailController.text.trim();
                          final password = passwordController.text.trim();

                          final success = await authService.login(
                            context,
                            email,
                            password,
                          );

                          if (success) {
                            // Ambil AuthProvider dan set login
                            final authProvider = Provider.of<AuthProvider>(context, listen: false);
                            await authProvider.login();

                            // Arahkan ke dashboard tanpa bisa kembali ke login
                            Navigator.pushReplacementNamed(
                              context,
                              route.student_dashboard,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Login failed! Check credentials."),
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
                          const Text("Don’t have an Account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, route.register);
                            },
                            child: const Text("SIGN UP"),
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
