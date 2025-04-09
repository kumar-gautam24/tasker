// lib/injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasker/src/data/local_datasource.dart';
import 'package:tasker/src/data/repo_impl.dart';
import 'package:tasker/src/domain/repo.dart';
import 'package:tasker/src/domain/usecase.dart';
import 'package:tasker/src/presentation/cubits/taskcard/task_card_cubit.dart';
import 'package:tasker/src/presentation/cubits/taskcreation/task_creation_cubit.dart';
import 'package:tasker/src/presentation/cubits/taskhistory/task_history_cubit.dart';


final sl = GetIt.instance;

Future<void> init() async {
  // Cubits
  sl.registerFactory(
    () => TaskCardCubit(
      getTodayTasks: sl(),
      completeTask: sl(),
    ),
  );
  
  sl.registerFactory(
    () => TaskCreationCubit(
      createTask: sl(),
      updateTask: sl(),
    ),
  );
  
  sl.registerFactory(
    () => TaskHistoryCubit(
      getTaskCompletionHistory: sl(),
      getAllTasks: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetTodayTasks(sl()));
  sl.registerLazySingleton(() => CompleteTask(sl(), sl()));
  sl.registerLazySingleton(() => CreateTask(sl()));
  sl.registerLazySingleton(() => UpdateTask(sl()));
  sl.registerLazySingleton(() => GetTaskCompletionHistory(sl()));

  // Repositories
  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(localDataSource: sl()),
  );
  
  sl.registerLazySingleton<TaskCompletionRepository>(
    () => TaskCompletionRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<LocalTaskDataSource>(
    () => LocalTaskDataSourceImpl(sharedPreferences: sl()),
  );
  
  sl.registerLazySingleton<LocalTaskCompletionDataSource>(
    () => LocalTaskCompletionDataSourceImpl(sharedPreferences: sl()),
  );

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}