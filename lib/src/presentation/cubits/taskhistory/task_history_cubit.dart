// lib/presentation/cubit/task_history_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tasker/src/domain/entity.dart';
import 'package:tasker/src/domain/repo.dart';
import 'package:tasker/src/domain/usecase.dart';

part 'task_history_state.dart';

class TaskHistoryCubit extends Cubit<TaskHistoryState> {
  final GetTaskCompletionHistory getTaskCompletionHistory;
  final TaskRepository taskRepository;

  TaskHistoryCubit({
    required this.getTaskCompletionHistory,
    required TaskRepository getAllTasks,
  }) : taskRepository = getAllTasks, super(TaskHistoryInitial());

  Future<void> loadHistoryForMonth(DateTime month) async {
    try {
      emit(TaskHistoryLoading());
      
      // Calculate first and last day of the month
      final firstDayOfMonth = DateTime(month.year, month.month, 1);
      final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);
      
      final historyMap = await getTaskCompletionHistory(
        startDate: firstDayOfMonth,
        endDate: lastDayOfMonth,
      );
      
      final tasks = await taskRepository.getAllTasks();
      
      emit(TaskHistoryLoaded(
        historyByDate: historyMap,
        tasks: tasks,
        month: month,
      ));
    } catch (error) {
      emit(TaskHistoryError(message: error.toString()));
    }
  }
}