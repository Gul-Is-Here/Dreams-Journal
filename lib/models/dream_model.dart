class Dream {
  final String id;
  final String title;
  final String description;
  final List<String> tags;
  final String mood;
  final DateTime date;

  Dream({
    required this.id,
    required this.title,
    required this.description,
    required this.tags,
    required this.mood,
    required this.date,
  });

  Dream copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? tags,
    String? mood,
    DateTime? date,
  }) {
    return Dream(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      mood: mood ?? this.mood,
      date: date ?? this.date,
    );
  }

  factory Dream.fromJson(Map<String, dynamic> json) {
    return Dream(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      tags: List<String>.from(json['tags']),
      mood: json['mood'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'tags': tags,
      'mood': mood,
      'date': date.toIso8601String(),
    };
  }
}