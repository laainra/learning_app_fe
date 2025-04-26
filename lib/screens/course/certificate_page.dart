import 'package:flutter/material.dart';

class CertificatePage extends StatelessWidget {
  const CertificatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: const Text("3D Design Illustration"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: const [
                    Text("Certificate of Completions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    Text("This Certifies that", style: TextStyle(fontSize: 14)),
                    Text("Alfina Aulia", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    Text("Has Successfully Completed the Wallace Training Program, Entitled"),
                    Text("Akuntansi Perpajakan", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    Text("ID: SK24568086"),
                    SizedBox(height: 16),
                    Text("Issued on November 24, 2022"),
                    SizedBox(height: 24),
                    Text("Calvin C. McGinnis", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Virginia M. Paterson"),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                icon: const Icon(Icons.download),
                label: const Text("Download Certificate"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
