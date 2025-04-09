part of 'task_creation_cubit.dart';

abstract class TaskCreationState extends Equatable {
  const TaskCreationState();
  
  @override
  List<Object> get props => [];
}

class TaskCreationInitial extends TaskCreationState {}

class TaskCreationLoading extends TaskCreationState {}

class TaskCreationSuccess extends TaskCreationState {}

class TaskCreationError extends TaskCreationState {
  final String message;

  const TaskCreationError({required this.message});

  @override
  List<Object> get props => [message];
}