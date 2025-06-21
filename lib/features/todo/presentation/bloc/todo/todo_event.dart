part of 'todo_bloc.dart';

@freezed
class TodoEvent with _$TodoEvent {
  const factory TodoEvent.loadTodos() = _LoadTodos;
  const factory TodoEvent.addTodo(Todo todo) = _AddTodo;
  const factory TodoEvent.updateTodo(Todo todo) = _UpdateTodo;
  const factory TodoEvent.deleteTodo(String id) = _DeleteTodo;
  const factory TodoEvent.toggleTodo(String id) = _ToggleTodo;
  const factory TodoEvent.filterTodos(TodoFilter filter) = _FilterTodos;
  const factory TodoEvent.searchTodos(String query) = _SearchTodos;
}