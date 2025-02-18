import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final TaskField title;
  final TaskField description;
  final bool status;
  final DateTime createdAt;

  Task({
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  factory Task.fromFirestore(Map<String, dynamic> json) {
    return Task(
      title: TaskField.fromJson(json['title']),
      description: TaskField.fromJson(json['description']),
      status: json['status'] ?? false,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title.toJson(),
      'description': description.toJson(),
      'status': status,
      'createdAt': createdAt,
    };
  }
}

class TaskField {
  final String en;
  final String es;

  TaskField({
    required this.en,
    required this.es,
  });

  factory TaskField.fromJson(Map<String, dynamic> json) {
    return TaskField(
      en: json['en'] ?? '',
      es: json['es'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'en': en,
      'es': es,
    };
  }

}
