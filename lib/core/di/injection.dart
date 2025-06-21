import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

import '../../features/todo/data/datasources/todo_local_datasource.dart';
import '../../features/todo/data/models/todo_model.dart';
import '../../features/todo/data/repositories/todo_repository_impl.dart';
import '../../features/todo/domain/repositories/todo_repository.dart';
import '../../features/todo/domain/usecases/add_todo.dart';
import '../../features/todo/domain/usecases/delete_todo.dart';
import '../../features/todo/domain/usecases/get_todos.dart';
import '../../features/todo/domain/usecases/toggle_todo.dart';
import '../../features/todo/domain/usecases/update_todo.dart';
import '../../features/todo/presentation/bloc/theme/theme_cubit.dart';
import '../../features/todo/presentation/bloc/todo/todo_bloc.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  // Register Hive adapters
  Hive.registerAdapter(TodoModelAdapter());
  Hive.registerAdapter(TodoPriorityAdapter());
  Hive.registerAdapter(TodoCategoryAdapter());
  
  // Open Hive boxes
  await Hive.openBox<TodoModel>('todos');
  await Hive.openBox('settings');
  
  // Register dependencies
  _registerCore();
  _registerDataSources();
  _registerRepositories();
  _registerUseCases();
  _registerBlocs();
}

void _registerCore() {
  getIt.registerLazySingleton<Logger>(() => Logger());
}

void _registerDataSources() {
  getIt.registerLazySingleton<TodoLocalDataSource>(
    () => TodoLocalDataSourceImpl(Hive.box<TodoModel>('todos')),
  );
}

void _registerRepositories() {
  getIt.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(getIt<TodoLocalDataSource>()),
  );
}

void _registerUseCases() {
  getIt.registerLazySingleton(() => GetTodos(getIt<TodoRepository>()));
  getIt.registerLazySingleton(() => AddTodo(getIt<TodoRepository>()));
  getIt.registerLazySingleton(() => UpdateTodo(getIt<TodoRepository>()));
  getIt.registerLazySingleton(() => DeleteTodo(getIt<TodoRepository>()));
  getIt.registerLazySingleton(() => ToggleTodo(getIt<TodoRepository>()));
}

void _registerBlocs() {
  getIt.registerFactory(() => ThemeCubit(Hive.box('settings')));
  getIt.registerFactory(() => TodoBloc(
    getTodos: getIt<GetTodos>(),
    addTodo: getIt<AddTodo>(),
    updateTodo: getIt<UpdateTodo>(),
    deleteTodo: getIt<DeleteTodo>(),
    toggleTodo: getIt<ToggleTodo>(),
    logger: getIt<Logger>(),
  ));
}