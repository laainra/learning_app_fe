class ChatRoom {
  final int id;
  final String mentorName;
  final String studentName;
  final String? lastMessage;
  final String? lastMessageTime;
  final int? unreadCount;

  ChatRoom({
    required this.id,
    required this.mentorName,
    required this.studentName,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      mentorName: json['mentor_name'],
      studentName: json['student_name'],
      lastMessage: json['last_message'] ?? '',
      lastMessageTime: json['last_message_time'] ?? '',
      unreadCount: json['unread_count'] ?? 0,
    );
  }
}