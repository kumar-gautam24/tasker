// lib/data/repositories/task_repository_impl.dart
import 'package:tasker/src/data/local_datasource.dart';
import 'package:tasker/src/data/model.dart';
import 'package:tasker/src/domain/entity.dart';
import 'package:tasker/src/domain/repo.dart';
class TaskRepositoryImpl implements TaskRepository {
  final LocalTaskDataSource localDataSource;

  TaskRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Task>> getAllTasks() async {
    final taskModels = await localDataSource.getAllTasks();
    return taskModels;
  }

  @override
  Future<Task?> getTaskById(String id) async {
    return await localDataSource.getTaskById(id);
  }

  @override
  Future<void> saveTask(Task task) async {
    await localDataSource.saveTask(TaskModel.fromEntity(task));
  }

  @override
  Future<void> deleteTask(String id) async {
    await localDataSource.deleteTask(id);
  }

  @override
  Future<List<Task>> getScheduledTasksForToday() async {
    final allTasks = await getAllTasks();
    final today = DateTime.now();
    final weekday = today.weekday;
    
    return allTasks.where((task) => task.schedule.isScheduledForDay(weekday)).toList();
  }
}

// lib/data/repositories/task_completion_repository_impl.dart

class TaskCompletionRepositoryImpl implements TaskCompletionRepository {
  final LocalTaskCompletionDataSource localDataSource;

  TaskCompletionRepositoryImpl({required this.localDataSource});

  @override
  Future<List<TaskCompletionRecord>> getCompletionRecordsForTask(String taskId) async {
    final records = await localDataSource.getCompletionRecordsForTask(taskId);
    return records;
  }

  @override
  Future<List<TaskCompletionRecord>> getCompletionRecordsForDate(DateTime date) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final records = await localDataSource.getCompletionRecordsForDate(normalizedDate);
    return records;
  }

  @override
  Future<void> saveCompletionRecord(TaskCompletionRecord record) async {
    await localDataSource.saveCompletionRecord(
      TaskCompletionRecordModel.fromEntity(record),
    );
  }

  @override
  Future<void> deleteCompletionRecord(String id) async {
    await localDataSource.deleteCompletionRecord(id);
  }

  @override
  Future<Map<DateTime, List<TaskCompletionRecord>>> getCompletionRecordsForDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final allRecords = await localDataSource.getAllCompletionRecords();
    
    final Map<DateTime, List<TaskCompletionRecord>> result = {};
    
    final normalizedStartDate = DateTime(startDate.year, startDate.month, startDate.day);
    final normalizedEndDate = DateTime(endDate.year, endDate.month, endDate.day);
    
    for (var record in allRecords) {
      final recordDate = DateTime(record.date.year, record.date.month, record.date.day);
      
      if (recordDate.isAtSameMomentAs(normalizedStartDate) || 
          recordDate.isAtSameMomentAs(normalizedEndDate) ||
          (recordDate.isAfter(normalizedStartDate) && recordDate.isBefore(normalizedEndDate))) {
        
        if (!result.containsKey(recordDate)) {
          result[recordDate] = [];
        }
        
        result[recordDate]!.add(record);
      }
    }
    
    return result;
  }
}