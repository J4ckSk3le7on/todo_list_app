import 'package:flutter/material.dart';
import 'package:todo_list_app/app/presentation/widgets/custom_check.dart';
import 'package:todo_list_app/app/presentation/widgets/custom_textfield.dart';
import 'package:todo_list_app/app/utils/snackbar_utils.dart';
import 'package:todo_list_app/core/firebase_models/task_model.dart';
import 'package:todo_list_app/data/task_service.dart';

class TaskDetailsPage extends StatefulWidget {
  final VoidCallback refresh;

  const TaskDetailsPage({
    super.key,
    required this.refresh
  });

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _completed = false;

  Future<void> _createTask() async {
    try {
      final TaskModel newTask = TaskModel(
        title: TaskField(es: _titleController.text, en: ""),
        description: TaskField(es: _descriptionController.text, en: ""),
        status: _completed,
        createdAt: DateTime.now()
      );
      await taskService.createTask(newTask: newTask);
      if (mounted) {
        Navigator.pop(context);
        widget.refresh();
      }
      widget.refresh();
    } catch (error) {
      snackBarUtils.showSnackbar(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task details"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async => _createTask(),
        icon: Icon(Icons.check_rounded),
        label: Text("Create"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: SingleChildScrollView(
          child: Column(
            spacing: 44,
            children: [
              CustomTextfield(
                title: "Title",
                textEditingController: _titleController
              ),
              CustomTextfield(
                title: "Description",
                textEditingController: _descriptionController
              ),
              CustomCheck(
                value: _completed,
                onChanged: (value) {
                  setState(() => _completed = value);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

}
