import 'package:flutter/material.dart';
import '../../routes/app_routes.dart' as route;

class IntroAuth extends StatefulWidget {
  const IntroAuth({super.key});

  @override
  State<IntroAuth> createState() => _IntroAuthState();
}

class _IntroAuthState extends State<IntroAuth> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF202244),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo bulat
            Image.asset("assets/images/intro.png", height: 300),
            const SizedBox(height: 24),

            Text(
              "Unlock Your Future, Learn with Us",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 22),
            Text(
              "Explore your interests, choose classes that suit your learning goals",
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Tombol Login
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        route.login,
                      ); // Ganti sesuai rute login kamu
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFC100),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                        vertical: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  // Tombol Register
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        route.register,
                      ); // Ganti sesuai rute login kamu
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFFFC100)),
                      foregroundColor: const Color(0xFFFFC100),
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Register",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
