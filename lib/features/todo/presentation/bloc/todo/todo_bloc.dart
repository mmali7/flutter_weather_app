import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';

import '../../../domain/entities/todo.dart';
import '../../../domain/usecases/add_todo.dart';
import '../../../domain/usecases/delete_todo.dart';
import '../../../domain/usecases/get_todos.dart';
import '../../../domain/usecases/toggle_todo.dart';
import '../../../domain/usecases/update_todo.dart';

part 'todo_event.dart';
part 'todo_state.dart';
part 'todo_bloc.freezed.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodos getTodos;
  final AddTodo addTodo;
  final UpdateTodo updateTodo;
  final DeleteTodo deleteTodo;
  final ToggleTodo toggleTodo;
  final Logger logger;

  TodoBloc({
    required this.getTodos,
    required this.addTodo,
    required this.updateTodo,
    required this.deleteTodo,
    required this.toggleTodo,
    required this.logger,
  }) : super(const TodoState.initial()) {
    on<TodoEvent>((event, emit) async {
      await event.when(
        loadTodos: () => _onLoadTodos(emit),
        addTodo: (todo) => _onAddTodo(emit, todo),
        updateTodo: (todo) => _onUpdateTodo(emit, todo),
        deleteTodo: (id) => _onDeleteTodo(emit, id),
        toggleTodo: (id) => _onToggleTodo(emit, id),
        filterTodos: (filter) => _onFilterTodos(emit, filter),
        searchTodos: (query) => _onSearchTodos(emit, query),
      );
    });
  }

  Future<void> _onLoadTodos(Emitter<TodoState> emit) async {
    try {
      emit(const TodoState.loading());
      final todos = await getTodos();
      emit(TodoState.loaded(todos: todos, filteredTodos: todos));
    } catch (e, stackTrace) {
      logger.e('Error loading todos', error: e, stackTrace: stackTrace);
      emit(TodoState.error(e.toString()));
    }
  }

  Future<void> _onAddTodo(Emitter<TodoState> emit, Todo todo) async {
    try {
      await addTodo(todo);
      final todos = await getTodos();
      final currentState = state;
      if (currentState is _Loaded) {
        final filteredTodos = _applyFilters(todos, currentState.filter, currentState.searchQuery);
        emit(currentState.copyWith(todos: todos, filteredTodos: filteredTodos));
      } else {
        emit(TodoState.loaded(todos: todos, filteredTodos: todos));
      }
    } catch (e, stackTrace) {
      logger.e('Error adding todo', error: e, stackTrace: stackTrace);
      emit(TodoState.error(e.toString()));
    }
  }

  Future<void> _onUpdateTodo(Emitter<TodoState> emit, Todo todo) async {
    try {
      await updateTodo(todo);
      final todos = await getTodos();
      final currentState = state;
      if (currentState is _Loaded) {
        final filteredTodos = _applyFilters(todos, currentState.filter, currentState.searchQuery);
        emit(currentState.copyWith(todos: todos, filteredTodos: filteredTodos));
      } else {
        emit(TodoState.loaded(todos: todos, filteredTodos: todos));
      }
    } catch (e, stackTrace) {
      logger.e('Error updating todo', error: e, stackTrace: stackTrace);
      emit(TodoState.error(e.toString()));
    }
  }

  Future<void> _onDeleteTodo(Emitter<TodoState> emit, String id) async {
    try {
      await deleteTodo(id);
      final todos = await getTodos();
      final currentState = state;
      if (currentState is _Loaded) {
        final filteredTodos = _applyFilters(todos, currentState.filter, currentState.searchQuery);
        emit(currentState.copyWith(todos: todos, filteredTodos: filteredTodos));
      } else {
        emit(TodoState.loaded(todos: todos, filteredTodos: todos));
      }
    } catch (e, stackTrace) {
      logger.e('Error deleting todo', error: e, stackTrace: stackTrace);
      emit(TodoState.error(e.toString()));
    }
  }

  Future<void> _onToggleTodo(Emitter<TodoState> emit, String id) async {
    try {
      await toggleTodo(id);
      final todos = await getTodos();
      final currentState = state;
      if (currentState is _Loaded) {
        final filteredTodos = _applyFilters(todos, currentState.filter, currentState.searchQuery);
        emit(currentState.copyWith(todos: todos, filteredTodos: filteredTodos));
      } else {
        emit(TodoState.loaded(todos: todos, filteredTodos: todos));
      }
    } catch (e, stackTrace) {
      logger.e('Error toggling todo', error: e, stackTrace: stackTrace);
      emit(TodoState.error(e.toString()));
    }
  }

  void _onFilterTodos(Emitter<TodoState> emit, TodoFilter filter) {
    final currentState = state;
    if (currentState is _Loaded) {
      final filteredTodos = _applyFilters(currentState.todos, filter, currentState.searchQuery);
      emit(currentState.copyWith(filter: filter, filteredTodos: filteredTodos));
    }
  }

  void _onSearchTodos(Emitter<TodoState> emit, String query) {
    final currentState = state;
    if (currentState is _Loaded) {
      final filteredTodos = _applyFilters(currentState.todos, currentState.filter, query);
      emit(currentState.copyWith(searchQuery: query, filteredTodos: filteredTodos));
    }
  }

  List<Todo> _applyFilters(List<Todo> todos, TodoFilter filter, String searchQuery) {
    var filtered = todos;

    // Apply filter
    switch (filter) {
      case TodoFilter.all:
        break;
      case TodoFilter.active:
        filtered = filtered.where((todo) => !todo.isCompleted).toList();
        break;
      case TodoFilter.completed:
        filtered = filtered.where((todo) => todo.isCompleted).toList();
        break;
      case TodoFilter.overdue:
        filtered = filtered.where((todo) => todo.isOverdue).toList();
        break;
      case TodoFilter.dueToday:
        filtered = filtered.where((todo) => todo.isDueToday).toList();
        break;
    }

    // Apply search
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((todo) =>
          todo.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          todo.description.toLowerCase().contains(searchQuery.toLowerCase())).toList();
    }

    return filtered;
  }
}