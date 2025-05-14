import 'package:finbedu/models/chat_room_model.dart';
import 'package:finbedu/providers/chat_provider.dart';
import 'package:finbedu/screens/chat/chat_room.dart';
import 'package:finbedu/screens/search/mentor_list.dart';
import 'package:finbedu/services/constants.dart';
import 'package:flutter/material.dart';
import 'package:finbedu/screens/course/course_screen.dart';
import 'package:finbedu/widgets/bottom_menu.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  _InboxPageState createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  late Future<List<ChatRoom>> _chatRoomsFuture;

  @override
  void initState() {
    super.initState();
    _loadChatRooms(); // Panggil fungsi untuk memuat chat rooms
  }

  void _loadChatRooms() {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    _chatRoomsFuture = chatProvider.fetchChatRooms();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Inbox"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _loadChatRooms(); // Refresh chat rooms saat tombol refresh ditekan
              });
            },
          ),
          if (currentUser?.role == "student")
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MentorListPage()),
                );
              },
            ),
        ],
      ),
      body: FutureBuilder<List<ChatRoom>>(
        future: _chatRoomsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Failed to load chat rooms: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No chat rooms available"));
          } else {
            final chatRooms = snapshot.data!;
            return ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: chatRooms.length,
              itemBuilder: (context, index) {
                final chatRoom = chatRooms[index];
                final otherUser =
                    chatRoom.mentor.id == currentUser?.id
                        ? chatRoom
                            .student // Jika pengguna login adalah mentor, otherUser adalah student
                        : chatRoom
                            .mentor; // Jika pengguna login adalah student, otherUser adalah mentor

                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatRoomPage(chatRoomId: chatRoom.id),
                      ),
                    );
                  },
                  leading: ClipOval(
                    child:
                        (otherUser.photo ?? '').isNotEmpty
                            ? Image.network(
                              '${ApiConstants.imgUrl}/${otherUser.photo}',
                              width: 50,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 50,
                                  height: 80,
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
                              width: 50,
                              height: 80,
                              color: Colors.white,
                              child: const Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                  ),
                  title: Text(otherUser.name ?? "Unknown"),
                  subtitle: Text(
                    chatRoom.lastMessage != null
                        ? (chatRoom.student.id == currentUser?.id
                            ? "Me: ${chatRoom.lastMessage}"
                            : "${otherUser.name}: ${chatRoom.lastMessage}")
                        : "No messages yet",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        chatRoom.lastMessageTime ?? "",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
    );
  }
}
