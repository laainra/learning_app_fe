import 'package:finbedu/models/category_model.dart';
import 'package:finbedu/models/user_model.dart';

class Course {
  final int? id;
  final int? categoryId;
  final String name;
  final String desc;
  final int? userId;
  final bool mediaFullAccess;
  final String level;
  final bool audioBook;
  final bool lifetimeAccess;
  final bool certificate;
  final String? image;
  final String price;
  final String? category;
  final UserModel? user;

  Course({
    this.id,
    required this.categoryId,
    required this.name,
    required this.desc,
    this.userId,
    this.mediaFullAccess = false,
    required this.level,
    this.audioBook = false,
    this.lifetimeAccess = false,
    this.certificate = false,
    this.image,
    required this.price,
    this.category,
    this.user,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      categoryId: json['category_id'],
      name: json['name'],
      desc: json['desc'],
      userId: json['user_id'],
      mediaFullAccess: json['media_full_access'] == 1, // Konversi int ke bool
      level: json['level'],
      audioBook: json['audio_book'] == 1, // Konversi int ke bool
      lifetimeAccess: json['lifetime_access'] == 1, // Konversi int ke bool
      certificate: json['certificate'] == 1, // Konversi int ke bool
      image: json['image'],
      price: json['price'],
      category:
          json['category'] != null
              ? json['category']['name']
              : null, // Ambil nama kategori dari objek JSON
      user: UserModel.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'name': name,
      'desc': desc,
      'media_full_access': mediaFullAccess ? 1 : 0, // Konversi bool ke int
      'level': level,
      'audio_book': audioBook ? 1 : 0, // Konversi bool ke int
      'lifetime_access': lifetimeAccess ? 1 : 0, // Konversi bool ke int
      'certificate': certificate ? 1 : 0, // Konversi bool ke int
      'image': image,
      'price': price,
    };
  }
}
