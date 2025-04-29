class Quiz {
  final int id;
  final int sectionId;
  final String sectionName; // Assuming section has a name

  Quiz({required this.id, required this.sectionId, required this.sectionName});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      sectionId: json['section_id'],
      sectionName: json['section']['name'], // Assuming section is embedded in the response
    );
  }
}
