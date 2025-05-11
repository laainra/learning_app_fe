import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finbedu/providers/user_provider.dart';
import 'package:finbedu/models/user_model.dart';
import 'package:finbedu/screens/chat/chat_room.dart';
import 'package:finbedu/screens/profile/mentor_profile.dart';

class MentorListPage extends StatelessWidget {
  const MentorListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mentor List"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: FutureBuilder<List<UserModel>>(
        future: userProvider.fetchMentors(), // Fetch mentors from backend
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No mentors available"));
          }

          final mentors = snapshot.data!;
          return ListView.builder(
            itemCount: mentors.length,
            itemBuilder: (context, index) {
              final mentor = mentors[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: Text(mentor.name[0]),
                ),
                title: Text(mentor.name),
                subtitle: Text(mentor.skill ?? "No specialization"),
                onTap: () {
                  // Navigasi ke halaman MentorProfilePage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MentorProfilePage(
                        name: mentor.name,
                        skill: mentor.skill ?? "No specialization",
                        image: mentor.photo ?? "assets/default_avatar.png", // Default image jika tidak ada foto
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}