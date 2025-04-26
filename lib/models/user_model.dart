class UserModel {
  final String name;
  final String email;
  final String? photo;
  final String? dob;
  final String? noTelp;
  final String? gender;
  final String? role;
  final String? skill;

  UserModel({
    required this.name,
    required this.email,
    this.photo,
    this.dob,
    this.noTelp,
    this.gender,
    this.role,
    this.skill,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      photo: json['photo'],
      dob: json['dob'],
      noTelp: json['no_telp'],
      gender: json['gender'],
      role: json['role'],
      skill: json['skill'],
    );
  }
}
