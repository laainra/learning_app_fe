import 'user_model.dart';

class ChatRoom {
  final int id;
  final UserModel mentor;
  final UserModel student;
  final String? lastMessage;
  final String? lastMessageTime;
  final int? unreadCount;

  ChatRoom({
    required this.id,
    required this.mentor,
    required this.student,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      mentor: UserModel.fromJson(json['mentor']),
      student: UserModel.fromJson(json['student']),
      lastMessage: json['last_message'] ?? '',
      lastMessageTime: json['last_message_time'] ?? '',
      unreadCount: json['unread_count'] ?? 0,
    );
  }
}