import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tasker/src/domain/entity.dart';
import 'package:tasker/src/domain/usecase.dart';

part 'task_card_state.dart';

class TaskCardCubit extends Cubit<TaskCardState> {
  final GetTodayTasks getTodayTasks;
  final CompleteTask completeTask;

  TaskCardCubit({
    required this.getTodayTasks,
    required this.completeTask,
  }) : super(TaskCardInitial());

  Future<void> loadTasks() async {
    try {
      emit(TaskCardLoading());
      final tasks = await getTodayTasks();
      
      if (tasks.isEmpty) {
        emit(TaskCardEmpty());
      } else {
        emit(TaskCardLoaded(tasks: tasks, currentIndex: 0));
      }
    } catch (error) {
      emit(TaskCardError(message: error.toString()));
    }
  }

  Future<void> markTaskAsCompleted(String taskId) async {
    try {
      await completeTask(taskId, TaskStatus.completed);
      _updateCurrentTasks();
    } catch (error) {
      emit(TaskCardError(message: error.toString()));
    }
  }

  Future<void> markTaskAsFailed(String taskId) async {
    try {
      await completeTask(taskId, TaskStatus.failed);
      _updateCurrentTasks();
    } catch (error) {
      emit(TaskCardError(message: error.toString()));
    }
  }

  Future<void> skipTask(String taskId) async {
    try {
      await completeTask(taskId, TaskStatus.skipped);
      
      final currentState = state;
      if (currentState is TaskCardLoaded) {
        final tasks = List<Task>.from(currentState.tasks);
        final currentTask = tasks.removeAt(currentState.currentIndex);
        tasks.add(currentTask);  // Move to back of queue
        
        emit(TaskCardLoaded(
          tasks: tasks,
          currentIndex: currentState.currentIndex < tasks.length ? currentState.currentIndex : 0,
        ));
      }
    } catch (error) {
      emit(TaskCardError(message: error.toString()));
    }
  }

  void _updateCurrentTasks() async {
    final currentState = state;
    if (currentState is TaskCardLoaded) {
      final tasks = List<Task>.from(currentState.tasks);
      tasks.removeAt(currentState.currentIndex);
      
      if (tasks.isEmpty) {
        emit(TaskCardEmpty());
      } else {
        emit(TaskCardLoaded(
          tasks: tasks,
          currentIndex: currentState.currentIndex < tasks.length ? currentState.currentIndex : 0,
        ));
      }
    }
  }
}
