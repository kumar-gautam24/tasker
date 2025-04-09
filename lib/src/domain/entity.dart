// lib/domain/entities/task.dart
import 'package:equatable/equatable.dart';

enum TaskStatus {
  pending,
  completed,
  skipped,
  failed
}

class WeekdaySchedule {
  final bool monday;
  final bool tuesday;
  final bool wednesday;
  final bool thursday;
  final bool friday;
  final bool saturday;
  final bool sunday;

  const WeekdaySchedule({
    this.monday = true,
    this.tuesday = true,
    this.wednesday = true,
    this.thursday = true,
    this.friday = true,
    this.saturday = true,
    this.sunday = true,
  });

  bool isScheduledForDay(int weekday) {
    switch (weekday) {
      case 1: return monday;
      case 2: return tuesday;
      case 3: return wednesday;
      case 4: return thursday;
      case 5: return friday;
      case 6: return saturday;
      case 7: return sunday;
      default: return false;
    }
  }
}

class Task extends Equatable {
  final String id;
  final String title;
  final String description;
  final WeekdaySchedule schedule;
  final DateTime createdAt;
  final DateTime? lastCompletedAt;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.schedule,
    required this.createdAt,
    this.lastCompletedAt,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    WeekdaySchedule? schedule,
    DateTime? createdAt,
    DateTime? lastCompletedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      schedule: schedule ?? this.schedule,
      createdAt: createdAt ?? this.createdAt,
      lastCompletedAt: lastCompletedAt ?? this.lastCompletedAt,
    );
  }

  @override
  List<Object?> get props => [id, title, description, schedule, createdAt, lastCompletedAt];
}


class TaskCompletionRecord extends Equatable {
  final String id;
  final String taskId;
  final DateTime date;
  final TaskStatus status;

  const TaskCompletionRecord({
    required this.id,
    required this.taskId,
    required this.date,
    required this.status,
  });

  @override
  List<Object> get props => [id, taskId, date, status];
}