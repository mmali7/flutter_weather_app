part of 'todo_bloc.dart';

enum TodoFilter { all, active, completed, overdue, dueToday }

@freezed
class TodoState with _$TodoState {
  const factory TodoState.initial() = _Initial;
  const factory TodoState.loading() = _Loading;
  const factory TodoState.loaded({
    required List<Todo> todos,
    required List<Todo> filteredTodos,
    @Default(TodoFilter.all) TodoFilter filter,
    @Default('') String searchQuery,
  }) = _Loaded;
  const factory TodoState.error(String message) = _Error;
}