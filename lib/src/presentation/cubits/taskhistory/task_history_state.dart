// lib/presentation/cubit/task_history_state.dart
part of 'task_history_cubit.dart';

abstract class TaskHistoryState extends Equatable {
  const TaskHistoryState();
  
  @override
  List<Object> get props => [];
}

class TaskHistoryInitial extends TaskHistoryState {}

class TaskHistoryLoading extends TaskHistoryState {}

class TaskHistoryLoaded extends TaskHistoryState {
  final Map<DateTime, List<TaskCompletionRecord>> historyByDate;
  final List<Task> tasks;
  final DateTime month;

  const TaskHistoryLoaded({
    required this.historyByDate,
    required this.tasks,
    required this.month,
  });
  
  Task? getTaskById(String taskId) {
    try {
      return tasks.firstWhere((task) => task.id == taskId);
    } catch (_) {
      return null;
    }
  }

  @override
  List<Object> get props => [historyByDate, tasks, month];
}

class TaskHistoryError extends TaskHistoryState {
  final String message;

  const TaskHistoryError({required this.message});

  @override
  List<Object> get props => [message];
}