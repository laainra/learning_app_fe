import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/certificate_provider.dart';

class CertificatePage extends StatefulWidget {
  final int courseAccessId;

  const CertificatePage({super.key, required this.courseAccessId});

  @override
  State<CertificatePage> createState() => _CertificatePageState();
}

class _CertificatePageState extends State<CertificatePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<CertificateProvider>(
        context,
        listen: false,
      ).generateCertificateProvider(widget.courseAccessId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: const Text("Certificate"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Consumer<CertificateProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const CircularProgressIndicator();
              }

              if (provider.errorMessage != null) {
                return Text(
                  provider.errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                );
              }

              final cert = provider.certificate;
              if (cert == null) {
                return const Text(
                  "Sertifikat tidak ditemukan.",
                  style: TextStyle(fontSize: 16),
                );
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Certificate of Completion",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "This certifies that",
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          cert.userId.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "has successfully completed the course titled:",
                          style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          cert.courseId.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text("Certificate ID: ${cert.certificateId}"),
                        const SizedBox(height: 8),
                        Text(
                          "Issued on ${cert.completedAt.toLocal().toString().split(' ')[0]}",
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 24),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Signature",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Implement download functionality here
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Download not implemented"),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    icon: const Icon(Icons.download),
                    label: const Text("Download Certificate"),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
