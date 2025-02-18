import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String? id;
  TaskField title;
  TaskField description;
  bool status;
  DateTime createdAt;

  TaskModel({
    this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      title: TaskField.fromJson(data['title']),
      description: TaskField.fromJson(data['description']),
      status: data['status'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
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
