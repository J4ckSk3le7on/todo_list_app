import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_app/app/presentation/task_details/task_details_page.dart';
import 'package:todo_list_app/app/utils/snackbar_utils.dart';
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
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tasks = [];
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadTasks(true);
    });
  }

  void _scrollListener() {
    if (!_isLoading && _hasMore && _scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadTasks(false);
    }
  }

  Future<void> _loadTasks(bool refresh) async {
    try {
      if (_isLoading) return;
      if (refresh) {
        setState(() {
          _tasks = [];
          _lastDocument = null;
          _hasMore = true;
        });
      }
      if (!_hasMore) return;
      setState(() => _isLoading = true);
      TaskPaginationModel result = await taskService.getTasks(lastDocument: _lastDocument);
      setState(() {
        _tasks.addAll(result.tasks);
        _lastDocument = result.lastDocument;
        _hasMore = result.hasMore;
        _isLoading = false;
      });
    } catch (error) {
      snackBarUtils.showSnackbar(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: Text("Todo-List App"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(
          builder: (context) => TaskDetailsPage(
            refresh: () => _loadTasks(true)
          )),
        ),
        label: Text("Create Task")
      ),
      body: RefreshIndicator(
        onRefresh: () => _loadTasks(true),
        child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
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
          controller: _scrollController
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

}
