import 'package:finbedu/providers/user_provider.dart';
import 'package:finbedu/widgets/bottom_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopMentorsPage extends StatefulWidget {
  const TopMentorsPage({super.key});

  @override
  State<TopMentorsPage> createState() => _TopMentorsPageState();
}

class _TopMentorsPageState extends State<TopMentorsPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMentors();
  }

  Future<void> _loadMentors() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.fetchMentors();
    } catch (e) {
      print('Failed to fetch mentors: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final mentors = userProvider.mentors;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Mentors'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : mentors.isEmpty
              ? const Center(child: Text('No mentors found.'))
              : ListView.builder(
                itemCount: mentors.length,
                itemBuilder: (context, index) {
                  final mentor = mentors[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundImage:
                          mentor.photo != null && mentor.photo!.isNotEmpty
                              ? NetworkImage(mentor.photo!)
                              : const AssetImage(
                                    'assets/images/default-avatar.png',
                                  )
                                  as ImageProvider,
                    ),
                    title: Text(
                      mentor.name ?? 'No Name',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      mentor.skill ?? 'No Skill',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    onTap: () {
                      // Navigasi ke halaman detail mentor jika tersedia
                    },
                  );
                },
              ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
    );
  }
}
