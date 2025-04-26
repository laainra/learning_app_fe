import 'package:flutter/material.dart';
import 'dart:async'; // Untuk Future.delayed

import 'intro_screen.dart'; // Ganti dengan path halaman intro kamu

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Tunggu 2 detik lalu navigasi ke halaman intro
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const IntroScreen()),
      );
    });
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
            Container(
              width: 160,
              height: 160,
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
            const SizedBox(height: 24),

            // Teks FINBEDU
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'FINB',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w300, // Light
                      fontStyle: FontStyle.italic,
                      fontSize: 64,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: 'EDU',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700, // Bold
                      fontSize: 64,
                      color: Color.fromARGB(255, 106, 218, 255),
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
