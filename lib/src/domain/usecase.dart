// lib/domain/usecases/get_today_tasks.dart
import 'package:tasker/src/domain/entity.dart';
import 'package:tasker/src/domain/repo.dart';

class GetTodayTasks {
  final TaskRepository repository;

  GetTodayTasks(this.repository);

  Future<List<Task>> call() async {
    return await repository.getScheduledTasksForToday();
  }
}

// lib/domain/usecases/complete_task.dart

class CompleteTask {
  final TaskRepository taskRepository;
  final TaskCompletionRepository completionRepository;

  CompleteTask(this.taskRepository, this.completionRepository);

  Future<void> call(String taskId, TaskStatus status) async {
    final task = await taskRepository.getTaskById(taskId);
    if (task == null) {
      throw Exception('Task not found');
    }

    final now = DateTime.now();
    final completionRecord = TaskCompletionRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      taskId: taskId,
      date: DateTime(now.year, now.month, now.day),
      status: status,
    );

    await completionRepository.saveCompletionRecord(completionRecord);

    if (status == TaskStatus.completed) {
      await taskRepository.saveTask(task.copyWith(lastCompletedAt: now));
    }
  }
}

// lib/domain/usecases/create_task.dart

class CreateTask {
  final TaskRepository repository;

  CreateTask(this.repository);

  Future<Task> call({
    required String title,
    required String description,
    required WeekdaySchedule schedule,
  }) async {
    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      schedule: schedule,
      createdAt: DateTime.now(),
    );

    await repository.saveTask(task);
    return task;
  }
}

// lib/domain/usecases/update_task.dart

class UpdateTask {
  final TaskRepository repository;

  UpdateTask(this.repository);

  Future<Task> call(Task task) async {
    await repository.saveTask(task);
    return task;
  }
}

// lib/domain/usecases/get_task_completion_history.dart

class GetTaskCompletionHistory {
  final TaskCompletionRepository repository;

  GetTaskCompletionHistory(this.repository);

  Future<Map<DateTime, List<TaskCompletionRecord>>> call({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return await repository.getCompletionRecordsForDateRange(startDate, endDate);
  }
}