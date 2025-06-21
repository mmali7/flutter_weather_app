import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:logger/logger.dart';

import 'package:flutter_todo_app/features/todo/domain/entities/todo.dart';
import 'package:flutter_todo_app/features/todo/domain/usecases/add_todo.dart';
import 'package:flutter_todo_app/features/todo/domain/usecases/delete_todo.dart';
import 'package:flutter_todo_app/features/todo/domain/usecases/get_todos.dart';
import 'package:flutter_todo_app/features/todo/domain/usecases/toggle_todo.dart';
import 'package:flutter_todo_app/features/todo/domain/usecases/update_todo.dart';
import 'package:flutter_todo_app/features/todo/presentation/bloc/todo/todo_bloc.dart';

class MockGetTodos extends Mock implements GetTodos {}
class MockAddTodo extends Mock implements AddTodo {}
class MockUpdateTodo extends Mock implements UpdateTodo {}
class MockDeleteTodo extends Mock implements DeleteTodo {}
class MockToggleTodo extends Mock implements ToggleTodo {}
class MockLogger extends Mock implements Logger {}

void main() {
  late TodoBloc bloc;
  late MockGetTodos mockGetTodos;
  late MockAddTodo mockAddTodo;
  late MockUpdateTodo mockUpdateTodo;
  late MockDeleteTodo mockDeleteTodo;
  late MockToggleTodo mockToggleTodo;
  late MockLogger mockLogger;

  setUp(() {
    mockGetTodos = MockGetTodos();
    mockAddTodo = MockAddTodo();
    mockUpdateTodo = MockUpdateTodo();
    mockDeleteTodo = MockDeleteTodo();
    mockToggleTodo = MockToggleTodo();
    mockLogger = MockLogger();
    
    bloc = TodoBloc(
      getTodos: mockGetTodos,
      addTodo: mockAddTodo,
      updateTodo: mockUpdateTodo,
      deleteTodo: mockDeleteTodo,
      toggleTodo: mockToggleTodo,
      logger: mockLogger,
    );
  });

  tearDown(() {
    bloc.close();
  });

  const tTodo = Todo(
    id: '1',
    title: 'Test Todo',
    description: 'Test Description',
    isCompleted: false,
    priority: TodoPriority.medium,
    category: TodoCategory.personal,
    createdAt: null,
  );

  const tTodos = [tTodo];

  group('TodoBloc', () {
    test('initial state should be TodoState.initial()', () {
      expect(bloc.state, equals(const TodoState.initial()));
    });

    blocTest<TodoBloc, TodoState>(
      'should emit [loading, loaded] when loadTodos is successful',
      build: () {
        when(() => mockGetTodos()).thenAnswer((_) async => tTodos);
        return bloc;
      },
      act: (bloc) => bloc.add(const TodoEvent.loadTodos()),
      expect: () => [
        const TodoState.loading(),
        const TodoState.loaded(todos: tTodos, filteredTodos: tTodos),
      ],
      verify: (_) {
        verify(() => mockGetTodos()).called(1);
      },
    );

    blocTest<TodoBloc, TodoState>(
      'should emit [loading, error] when loadTodos fails',
      build: () {
        when(() => mockGetTodos()).thenThrow(Exception('Failed to load todos'));
        return bloc;
      },
      act: (bloc) => bloc.add(const TodoEvent.loadTodos()),
      expect: () => [
        const TodoState.loading(),
        const TodoState.error('Exception: Failed to load todos'),
      ],
    );
  });
}