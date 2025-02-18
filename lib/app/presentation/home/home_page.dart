import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_app/core/firebase_models/task_model.dart';
import 'package:todo_list_app/core/firebase_models/task_pagination_model.dart';
import 'package:todo_list_app/data/task_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<TaskModel> _tasks;
  bool _isLoading = false;
  bool _hasMore = true;
  DocumentSnapshot? _lastDocument;

  @override
  void initState() {
    super.initState();
    _tasks = [];
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadTasks();
    });
  }

  Future<void> loadTasks() async {
    if (_isLoading || !_hasMore) return;
    setState(() => _isLoading = true);
    TaskPaginationModel result = await taskService.getTasks(lastDocument: _lastDocument);
    setState(() {
      _tasks.addAll(result.tasks);
      _lastDocument = result.lastDocument;
      _hasMore = result.hasMore;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo-List App"),
      ),
      body: ListView.builder(
        itemCount: _tasks.length + 1,
        itemBuilder: (context, index) {
          if (index == _tasks.length) {
            return _hasMore ? Center(child: CircularProgressIndicator())
              : Center(child: Text('No more tasks'));
          }
          var task = _tasks[index];
          return ListTile(
            title: Text(task.title.es),
            subtitle: Text(task.status ? 'Completed' : 'Pending'),
            trailing: Text(task.createdAt.toString()),
          );
        },
        controller: ScrollController()..addListener(() {
          if (!_isLoading && _hasMore && ScrollController().position.pixels ==
          ScrollController().position.maxScrollExtent) {
            loadTasks();
          }
        }),
      ),
    );
  }

}
