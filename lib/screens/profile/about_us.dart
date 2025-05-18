import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(
          255,
          243,
          244,
          245,
        ), // Warna biru yang cocok untuk aplikasi finansial
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Image
            Container(
              width: double.infinity,
              height: 180,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 190, 220, 239),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text(
                                'FINB',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color(0xFF202244),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Finb Edu',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF202244),
                      ),
                    ),
                    const Text(
                      'Solusi Edukatif Keuangan dan Perbankan',
                      style: TextStyle(fontSize: 14, color: Color(0xFF202244)),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // About Us Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About Us',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF202244),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Finb edu adalah aplikasi pembelajaran keuangan dan perbankan yang dikembangkan sebagai solusi edukatif berbasis teknologi untuk meningkatkan literasi keuangan mahasiswa. Kami percaya bahwa pemahaman keuangan yang baik menjadi fondasi penting bagi generasi muda dalam menghadapi tantangan ekonomi masa kini dan masa depan.',
                    style: TextStyle(fontSize: 14, height: 1.5),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Dengan menggabungkan pendekatan edukasi dan teknologi (edutech), finb edu menyajikan konten pembelajaran yang interaktif, mulai dari materi teoritis, latihan soal, hingga simulasi dunia nyata di bidang keuangan dan perbankan. Aplikasi ini mendukung proses belajar yang fleksibel, mudah diakses, dan sesuai dengan kebutuhan pelajar serta perkembangan industri keuangan modern.',
                    style: TextStyle(fontSize: 14, height: 1.5),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Misi kami adalah menciptakan generasi cerdas finansial melalui pendidikan digital yang inklusif dan berkelanjutan.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Developer Team Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tim Pengembang',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF202244),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Leader Card
                  _buildTeamMemberCard(
                    name: 'Fitriana Rakhma Dhanias., SE., MSA., Ak., CFP',
                    role: 'Leader',
                    email: 'fitriana.dhanias@ub.ac.id',
                    position:
                        'Ketua Program Studi D-III Keuangan Dan Perbankan Universitas Brawijaya',
                    isLeader: true,
                  ),

                  const SizedBox(height: 10),

                  // Member Cards
                  _buildTeamMemberCard(
                    name: 'Alfina Aulia Yuhernanda',
                    role: 'Member',
                    email: 'alfiyhnd@student.ub.ac.id',
                  ),
                  const SizedBox(height: 10),
                  _buildTeamMemberCard(
                    name: 'Ganda Tri Banowati',
                    role: 'Member',
                    email: 'andtrist@student.ub.ac.id',
                  ),
                  const SizedBox(height: 10),
                  _buildTeamMemberCard(
                    name: 'Hikma Anuqra',
                    role: 'Member',
                    email: 'hikmaanuqra@student.ub.ac.id',
                  ),
                  const SizedBox(height: 10),
                  _buildTeamMemberCard(
                    name: 'Raelina Cristiani Simamora',
                    role: 'Member',
                    email: 'raelina@student.ub.ac.id',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Contact Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              color: const Color(0xFFE3F2FD),
              child: Column(
                children: [
                  const Text(
                    'Hubungi Kami',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF202244),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.email, color: Color(0xFF0D47A1)),
                        onPressed: () {
                          // Fungsi untuk mengirim email
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.phone, color: Color(0xFF0D47A1)),
                        onPressed: () {
                          // Fungsi untuk menelepon
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.web, color: Color(0xFF0D47A1)),
                        onPressed: () {
                          // Fungsi untuk membuka website
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Footer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              color: const Color(0xFF202244),
              child: const Center(
                child: Text(
                  '© 2025 Finb Edu - All Rights Reserved',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMemberCard({
    required String name,
    required String role,
    required String email,
    String position = '',
    bool isLeader = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLeader ? const Color(0xFFE3F2FD) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF0D47A1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    name.substring(0, 1),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isLeader
                                    ? const Color(0xFF0D47A1)
                                    : const Color(0xFF90CAF9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            role,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.email, size: 16, color: Color(0xFF0D47A1)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  email,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ],
          ),
          if (position.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.work, size: 16, color: Color(0xFF0D47A1)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    position,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
