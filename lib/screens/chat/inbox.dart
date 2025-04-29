import 'package:finbedu/screens/chat/chat_room.dart';
import 'package:flutter/material.dart';
import 'package:finbedu/screens/course/course_screen.dart';
import 'package:finbedu/widgets/bottom_menu.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    final chatList = [
      {
        "name": "Natasha",
        "message": "Hi, Good Evening Bro.!",
        "time": "14:59",
        "unread": "03",
      },
      {
        "name": "Alex",
        "message": "I Just Finished It.!",
        "time": "06:35",
        "unread": "02",
      },
      {"name": "John", "message": "How are you?", "time": "08:10"},
      {
        "name": "Mia",
        "message": "OMG, This is Amazing..",
        "time": "21:07",
        "unread": "05",
      },
      {"name": "Maria", "message": "Wow, This is Really Epic", "time": "09:15"},
      {
        "name": "Tiya",
        "message": "Hi, Good Evening Bro.!",
        "time": "14:59",
        "unread": "03",
      },
      {
        "name": "Manisha",
        "message": "I Just Finished It.!",
        "time": "06:35",
        "unread": "02",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Inbox"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A214C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              child: const Center(child: Text("Room Chat With Mentor")),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: chatList.length,
              itemBuilder: (context, index) {
                final chat = chatList[index];
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ChatRoomPage()),
                    );
                  },
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    child: Text(chat["name"]![0]),
                  ),
                  title: Text(chat["name"]!),
                  subtitle: Text(
                    chat["message"]!,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(chat["time"]!),
                      if (chat.containsKey("unread"))
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            chat["unread"]!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
    );
  }
}
