// lib/presentation/cubit/task_creation_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tasker/src/domain/entity.dart';
import 'package:tasker/src/domain/usecase.dart';

part 'task_creation_state.dart';

class TaskCreationCubit extends Cubit<TaskCreationState> {
  final CreateTask createTask;
  final UpdateTask updateTask;

  TaskCreationCubit({
    required this.createTask,
    required this.updateTask,
  }) : super(TaskCreationInitial());

  Future<void> createNewTask({
    required String title,
    required String description,
    required WeekdaySchedule schedule,
  }) async {
    try {
      emit(TaskCreationLoading());
      
      await createTask(
        title: title,
        description: description,
        schedule: schedule,
      );
      
      emit(TaskCreationSuccess());
    } catch (error) {
      emit(TaskCreationError(message: error.toString()));
    }
  }

  Future<void> editExistingTask(Task task) async {
    try {
      emit(TaskCreationLoading());
      
      await updateTask(task);
      
      emit(TaskCreationSuccess());
    } catch (error) {
      emit(TaskCreationError(message: error.toString()));
    }
  }
}
