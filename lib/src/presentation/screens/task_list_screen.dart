// lib/presentation/screens/tasks_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasker/injection_cotainer.dart' as di;
import 'package:tasker/src/domain/entity.dart';
import 'package:tasker/src/domain/repo.dart';
import 'package:tasker/src/presentation/cubits/taskcreation/task_creation_cubit.dart';
import 'task_creation_screen.dart';

class TasksListScreen extends StatefulWidget {
  const TasksListScreen({super.key});

  @override
  State<TasksListScreen> createState() => _TasksListScreenState();
}

class _TasksListScreenState extends State<TasksListScreen> {
  List<Task> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final repository = di.sl<TaskRepository>();
      final tasks = await repository.getAllTasks();
      
      setState(() {
        _tasks = tasks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading tasks: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildTasksList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => di.sl<TaskCreationCubit>(),
                child: const TaskCreationScreen(),
              ),
            ),
          );
          
          if (result == true) {
            _loadTasks();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTasksList() {
    if (_tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.list_alt,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'No Tasks Yet',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to create your first task',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        final task = _tasks[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(task.title),
            subtitle: Text(
              task.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => di.sl<TaskCreationCubit>(),
                          child: TaskCreationScreen(taskToEdit: task),
                        ),
                      ),
                    );
                    
                    if (result == true) {
                      _loadTasks();
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Task'),
                        content: Text('Are you sure you want to delete "${task.title}"?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Delete', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                    
                    if (confirm == true) {
                      try {
                        final repository = di.sl<TaskRepository>();
                        await repository.deleteTask(task.id);
                        _loadTasks();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error deleting task: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => _buildTaskDetailsSheet(task),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTaskDetailsSheet(Task task) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            task.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Text(
            'Schedule',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              if (task.schedule.monday) _buildDayChip(context, 'MON'),
              if (task.schedule.tuesday) _buildDayChip(context, 'TUE'),
              if (task.schedule.wednesday) _buildDayChip(context, 'WED'),
              if (task.schedule.thursday) _buildDayChip(context, 'THU'),
              if (task.schedule.friday) _buildDayChip(context, 'FRI'),
              if (task.schedule.saturday) _buildDayChip(context, 'SAT'),
              if (task.schedule.sunday) _buildDayChip(context, 'SUN'),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Last Completed',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            task.lastCompletedAt != null
                ? '${task.lastCompletedAt!.day}/${task.lastCompletedAt!.month}/${task.lastCompletedAt!.year}'
                : 'Never completed',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildDayChip(BuildContext context, String day) {
    return Chip(
      label: Text(day),
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
      labelStyle: TextStyle(
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
