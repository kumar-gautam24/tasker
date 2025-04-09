// lib/data/datasources/local_task_data_source.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasker/src/data/model.dart';
abstract class LocalTaskDataSource {
  Future<List<TaskModel>> getAllTasks();
  Future<TaskModel?> getTaskById(String id);
  Future<void> saveTask(TaskModel task);
  Future<void> deleteTask(String id);
}

class LocalTaskDataSourceImpl implements LocalTaskDataSource {
  final SharedPreferences sharedPreferences;
  static const String TASKS_KEY = 'tasks';

  LocalTaskDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<TaskModel>> getAllTasks() async {
    final jsonString = sharedPreferences.getString(TASKS_KEY);
    if (jsonString == null) {
      return [];
    }
    
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((jsonTask) => TaskModel.fromJson(jsonTask)).toList();
  }

  @override
  Future<TaskModel?> getTaskById(String id) async {
    final tasks = await getAllTasks();
    try {
      return tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveTask(TaskModel task) async {
    final tasks = await getAllTasks();
    final taskIndex = tasks.indexWhere((t) => t.id == task.id);
    
    if (taskIndex >= 0) {
      tasks[taskIndex] = task;
    } else {
      tasks.add(task);
    }
    
    await sharedPreferences.setString(
      TASKS_KEY,
      json.encode(tasks.map((t) => t.toJson()).toList()),
    );
  }

  @override
  Future<void> deleteTask(String id) async {
    final tasks = await getAllTasks();
    tasks.removeWhere((task) => task.id == id);
    
    await sharedPreferences.setString(
      TASKS_KEY,
      json.encode(tasks.map((t) => t.toJson()).toList()),
    );
  }
}

// lib/data/datasources/local_task_completion_data_source.dart
abstract class LocalTaskCompletionDataSource {
  Future<List<TaskCompletionRecordModel>> getAllCompletionRecords();
  Future<List<TaskCompletionRecordModel>> getCompletionRecordsForTask(String taskId);
  Future<List<TaskCompletionRecordModel>> getCompletionRecordsForDate(DateTime date);
  Future<void> saveCompletionRecord(TaskCompletionRecordModel record);
  Future<void> deleteCompletionRecord(String id);
}

class LocalTaskCompletionDataSourceImpl implements LocalTaskCompletionDataSource {
  final SharedPreferences sharedPreferences;
  static const String COMPLETION_RECORDS_KEY = 'completion_records';

  LocalTaskCompletionDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<TaskCompletionRecordModel>> getAllCompletionRecords() async {
    final jsonString = sharedPreferences.getString(COMPLETION_RECORDS_KEY);
    if (jsonString == null) {
      return [];
    }
    
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => TaskCompletionRecordModel.fromJson(json)).toList();
  }

  @override
  Future<List<TaskCompletionRecordModel>> getCompletionRecordsForTask(String taskId) async {
    final records = await getAllCompletionRecords();
    return records.where((record) => record.taskId == taskId).toList();
  }

  @override
  Future<List<TaskCompletionRecordModel>> getCompletionRecordsForDate(DateTime date) async {
    final records = await getAllCompletionRecords();
    return records.where((record) => 
      record.date.year == date.year && 
      record.date.month == date.month && 
      record.date.day == date.day
    ).toList();
  }

  @override
  Future<void> saveCompletionRecord(TaskCompletionRecordModel record) async {
    final records = await getAllCompletionRecords();
    final recordIndex = records.indexWhere((r) => r.id == record.id);
    
    if (recordIndex >= 0) {
      records[recordIndex] = record;
    } else {
      records.add(record);
    }
    
    await sharedPreferences.setString(
      COMPLETION_RECORDS_KEY,
      json.encode(records.map((r) => r.toJson()).toList()),
    );
  }

  @override
  Future<void> deleteCompletionRecord(String id) async {
    final records = await getAllCompletionRecords();
    records.removeWhere((record) => record.id == id);
    
    await sharedPreferences.setString(
      COMPLETION_RECORDS_KEY,
      json.encode(records.map((r) => r.toJson()).toList()),
    );
  }
}