import 'package:finbedu/providers/chat_provider.dart';
import 'package:finbedu/providers/user_provider.dart';
import 'package:finbedu/screens/chat/chat_room.dart';
import 'package:finbedu/services/constants.dart';
import 'package:finbedu/widgets/bottom_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MentorListPage extends StatefulWidget {
  const MentorListPage({super.key});

  @override
  State<MentorListPage> createState() => _MentorListPageState();
}

class _MentorListPageState extends State<MentorListPage> {
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

  Future<void> _createChatRoom(int mentorId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    try {
      final studentId = userProvider.user?.id;

      if (mentorId == null || studentId == null) {
        throw Exception('Mentor ID or Student ID is null');
      }

      print(
        'Creating chat room with mentorId: $mentorId, studentId: $studentId',
      );

      final chatRoom = await chatProvider.createChatRoom(mentorId, studentId);

      // Navigasi ke halaman chat room setelah berhasil membuat chat room
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatRoomPage(chatRoomId: chatRoom.id),
        ),
      );
    } catch (e) {
      print('Error creating chat room: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal membuat chat room')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final mentors = userProvider.mentors;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mentors'),
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
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          ClipOval(
                            child:
                                (mentor.photo ?? '').isNotEmpty
                                    ? Image.network(
                                      '${Constants.imgUrl}/${mentor.photo}',
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Container(
                                          width: 70,
                                          height: 70,
                                          color: Colors.white,
                                          child: const Icon(
                                            Icons.person,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                        );
                                      },
                                    )
                                    : Container(
                                      width: 70,
                                      height: 70,
                                      color: Colors.white,
                                      child: const Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                    ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  mentor.name ?? 'No Name',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  mentor.skill ?? 'No Skill',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () async {
                              await _createChatRoom(mentor.id!);
                            },
                            child: const Text(
                              'Message',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF202244),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
    );
  }
}
