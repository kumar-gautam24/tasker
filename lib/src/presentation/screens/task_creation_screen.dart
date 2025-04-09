// lib/presentation/screens/task_creation_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasker/src/domain/entity.dart';
import 'package:tasker/src/presentation/cubits/taskcreation/task_creation_cubit.dart';
import 'package:tasker/src/presentation/widgets/widgets.dart';

class TaskCreationScreen extends StatelessWidget {
  final Task? taskToEdit;

  const TaskCreationScreen({
    super.key,
    this.taskToEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(taskToEdit == null ? 'Create Task' : 'Edit Task'),
      ),
      body: BlocConsumer<TaskCreationCubit, TaskCreationState>(
        listener: (context, state) {
          if (state is TaskCreationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  taskToEdit == null 
                      ? 'Task created successfully' 
                      : 'Task updated successfully'
                ),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop(true);
          } else if (state is TaskCreationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TaskForm(
                    initialTask: taskToEdit,
                    onSubmit: (title, description, schedule) {
                      if (taskToEdit == null) {
                        context.read<TaskCreationCubit>().createNewTask(
                          title: title,
                          description: description,
                          schedule: schedule,
                        );
                      } else {
                        final updatedTask = taskToEdit!.copyWith(
                          title: title,
                          description: description,
                          schedule: schedule,
                        );
                        context.read<TaskCreationCubit>().editExistingTask(updatedTask);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
