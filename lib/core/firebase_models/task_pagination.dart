import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list_app/core/firebase_models/task_model.dart';

class TaskPagination {
  final List<Task> tasks;
  final DocumentSnapshot? lastDocument;
  final bool hasMore;

  TaskPagination({
    required this.tasks,
    required this.lastDocument,
    required this.hasMore,
  });

  factory TaskPagination.fromFirestore(QuerySnapshot querySnapshot) {
    List<Task> tasks = querySnapshot.docs.map((doc) {
      return Task.fromFirestore(doc.data() as Map<String, dynamic>);
    }).toList();

    bool hasMore = querySnapshot.docs.length == 10;

    DocumentSnapshot? lastDoc = querySnapshot.docs.isNotEmpty
        ? querySnapshot.docs.last
        : null;

    return TaskPagination(
      tasks: tasks,
      lastDocument: lastDoc,
      hasMore: hasMore,
    );
  }

}
