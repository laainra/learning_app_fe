class Chat {
  final int id;
  final int userId;
  final String message;
  final String? attachment;
  final String createdAt;

  Chat({
    required this.id,
    required this.userId,
    required this.message,
    this.attachment,
    required this.createdAt,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      userId: json['user_id'],
      message: json['message'],
      attachment: json['attachment'],
      createdAt: json['created_at'],
    );
  }
}