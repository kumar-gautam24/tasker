import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasker/src/presentation/cubits/taskcard/task_card_cubit.dart';
import 'package:tasker/src/presentation/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TaskCardCubit>().loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TaskCardCubit, TaskCardState>(
        builder: (context, state) {
          if (state is TaskCardLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskCardEmpty) {
            return _buildEmptyState();
          } else if (state is TaskCardLoaded) {
            return _buildTaskCard(state);
          } else if (state is TaskCardError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('Something went wrong'));
          }
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'All Done!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You have completed all your tasks for today.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<TaskCardCubit>().loadTasks();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(TaskCardLoaded state) {
    final task = state.currentTask;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Tasks for Today',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        Text(
          '${state.currentIndex + 1} of ${state.tasks.length}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 16),
        SwipeableTaskCard(
          task: task,
          onCompleted: () {
            context.read<TaskCardCubit>().markTaskAsCompleted(task.id);
          },
          onFailed: () {
            context.read<TaskCardCubit>().markTaskAsFailed(task.id);
          },
          onSkipped: () {
            context.read<TaskCardCubit>().skipTask(task.id);
          },
        ),
      ],
    );
  }
}
