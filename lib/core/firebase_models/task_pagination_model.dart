import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list_app/core/firebase_models/task_model.dart';

class TaskPaginationModel {
  final List<TaskModel> tasks;
  final DocumentSnapshot? lastDocument;
  final bool hasMore;

  TaskPaginationModel({
    required this.tasks,
    required this.lastDocument,
    required this.hasMore,
  });

  factory TaskPaginationModel.fromFirestore(QuerySnapshot querySnapshot) {
    List<TaskModel> tasks = querySnapshot.docs.map((doc) {
      return TaskModel.fromFirestore(doc);
    }).toList();

    bool hasMore = querySnapshot.docs.length == 10;

    DocumentSnapshot? lastDoc = querySnapshot.docs.isNotEmpty
        ? querySnapshot.docs.last
        : null;

    return TaskPaginationModel(
      tasks: tasks,
      lastDocument: lastDoc,
      hasMore: hasMore,
    );
  }

}
