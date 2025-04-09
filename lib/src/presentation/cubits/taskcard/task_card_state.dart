part of 'task_card_cubit.dart';

abstract class TaskCardState extends Equatable {
  const TaskCardState();
  
  @override
  List<Object> get props => [];
}

class TaskCardInitial extends TaskCardState {}

class TaskCardLoading extends TaskCardState {}

class TaskCardLoaded extends TaskCardState {
  final List<Task> tasks;
  final int currentIndex;

  const TaskCardLoaded({
    required this.tasks,
    required this.currentIndex,
  });

  Task get currentTask => tasks[currentIndex];

  @override
  List<Object> get props => [tasks, currentIndex];
}

class TaskCardEmpty extends TaskCardState {}

class TaskCardError extends TaskCardState {
  final String message;

  const TaskCardError({required this.message});

  @override
  List<Object> get props => [message];
}
