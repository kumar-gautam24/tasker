// lib/domain/repositories/task_repository.dart

import 'package:tasker/src/domain/entity.dart';

abstract class TaskRepository {
  Future<List<Task>> getAllTasks();
  Future<Task?> getTaskById(String id);
  Future<void> saveTask(Task task);
  Future<void> deleteTask(String id);
  Future<List<Task>> getScheduledTasksForToday();
}


abstract class TaskCompletionRepository {
  Future<List<TaskCompletionRecord>> getCompletionRecordsForTask(String taskId);
  Future<List<TaskCompletionRecord>> getCompletionRecordsForDate(DateTime date);
  Future<void> saveCompletionRecord(TaskCompletionRecord record);
  Future<void> deleteCompletionRecord(String id);
  Future<Map<DateTime, List<TaskCompletionRecord>>> getCompletionRecordsForDateRange(
    DateTime startDate,
    DateTime endDate,
  );
}