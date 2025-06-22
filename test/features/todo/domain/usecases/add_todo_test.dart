import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_todo_app/features/todo/domain/entities/todo.dart';
import 'package:flutter_todo_app/features/todo/domain/repositories/todo_repository.dart';
import 'package:flutter_todo_app/features/todo/domain/usecases/add_todo.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late AddTodo usecase;
  late MockTodoRepository mockRepository;

  setUp(() {
    mockRepository = MockTodoRepository();
    usecase = AddTodo(mockRepository);
  });

  final tTodo = Todo(
    id: '1',
    title: 'Test Todo',
    description: 'Test Description',
    isCompleted: false,
    priority: TodoPriority.medium,
    category: TodoCategory.personal,
    createdAt: DateTime.now(),
  );

  test('should add todo to repository', () async {
    // arrange
    when(() => mockRepository.addTodo(any())).thenAnswer((_) async {});

    // act
    await usecase(tTodo);

    // assert
    verify(() => mockRepository.addTodo(tTodo));
    verifyNoMoreInteractions(mockRepository);
  });
}