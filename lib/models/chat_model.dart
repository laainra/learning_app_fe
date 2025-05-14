import 'package:finbedu/models/user_model.dart';

class Chat {
  int id;
  int userId;
  String text;
  bool isMe;
  String time; // Ubah dari final menjadi mutable
  String? attachment;
  String status; // Ubah dari final menjadi mutable
  UserModel? user;

  Chat({
    required this.id,
    required this.userId,
    required this.text,
    required this.isMe,
    required this.time,
    this.attachment,
    required this.status,
    this.user,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      userId: json['user_id'],
      text: json['text'] ?? '',
      isMe: json['isMe'] ?? false,
      time: json['created_at'] ?? '',
      attachment: json['attachment'],
      status: "sent", // Default status untuk pesan dari server
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }
}
