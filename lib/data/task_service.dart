import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list_app/core/firebase_models/task_model.dart';
import 'package:todo_list_app/core/firebase_models/task_pagination_model.dart';

class _TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final int documentLimit = 10;

  Future<TaskPaginationModel> getTasks({DocumentSnapshot? lastDocument}) async {
    Query query = _firestore.collection('task').orderBy('status').orderBy('createdAt', descending: true).limit(documentLimit);
    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }
    QuerySnapshot querySnapshot = await query.get();
    return TaskPaginationModel.fromFirestore(querySnapshot);
  }

  Future createTask({required TaskModel newTask}) async {
    await _firestore.collection('task').add(newTask.toFirestore());
  }

  Future<void> updateTaskStatus({required String taskId, required bool status}) async {
    await _firestore.collection('task').doc(taskId).update({'status': status});
  }

}

final taskService = _TaskService();
