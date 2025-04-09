

import 'package:tasker/src/domain/entity.dart';

class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.title,
    required super.description,
    required super.schedule,
    required super.createdAt,
    super.lastCompletedAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      schedule: WeekdaySchedule(
        monday: json['monday'] ?? true,
        tuesday: json['tuesday'] ?? true,
        wednesday: json['wednesday'] ?? true,
        thursday: json['thursday'] ?? true,
        friday: json['friday'] ?? true,
        saturday: json['saturday'] ?? true,
        sunday: json['sunday'] ?? true,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      lastCompletedAt: json['lastCompletedAt'] != null
          ? DateTime.parse(json['lastCompletedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final scheduleMap = {
      'monday': schedule.monday,
      'tuesday': schedule.tuesday,
      'wednesday': schedule.wednesday,
      'thursday': schedule.thursday,
      'friday': schedule.friday,
      'saturday': schedule.saturday,
      'sunday': schedule.sunday,
    };

    return {
      'id': id,
      'title': title,
      'description': description,
      ...scheduleMap,
      'createdAt': createdAt.toIso8601String(),
      'lastCompletedAt': lastCompletedAt?.toIso8601String(),
    };
  }

  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      schedule: task.schedule,
      createdAt: task.createdAt,
      lastCompletedAt: task.lastCompletedAt,
    );
  }
}

class TaskCompletionRecordModel extends TaskCompletionRecord {
  const TaskCompletionRecordModel({
    required super.id,
    required super.taskId,
    required super.date,
    required super.status,
  });

  factory TaskCompletionRecordModel.fromJson(Map<String, dynamic> json) {
    return TaskCompletionRecordModel(
      id: json['id'],
      taskId: json['taskId'],
      date: DateTime.parse(json['date']),
      status: TaskStatus.values[json['status']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'taskId': taskId,
      'date': date.toIso8601String(),
      'status': status.index,
    };
  }

  factory TaskCompletionRecordModel.fromEntity(TaskCompletionRecord record) {
    return TaskCompletionRecordModel(
      id: record.id,
      taskId: record.taskId,
      date: record.date,
      status: record.status,
    );
  }
}