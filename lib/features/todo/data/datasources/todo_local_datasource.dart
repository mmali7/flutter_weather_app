import 'package:hive/hive.dart';
import '../models/todo_model.dart';

abstract class TodoLocalDataSource {
  Future<List<TodoModel>> getTodos();
  Future<void> addTodo(TodoModel todo);
  Future<void> updateTodo(TodoModel todo);
  Future<void> deleteTodo(String id);
  Stream<List<TodoModel>> watchTodos();
}

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  final Box<TodoModel> _todoBox;

  TodoLocalDataSourceImpl(this._todoBox);

  @override
  Future<List<TodoModel>> getTodos() async {
    return _todoBox.values.toList();
  }

  @override
  Future<void> addTodo(TodoModel todo) async {
    await _todoBox.put(todo.id, todo);
  }

  @override
  Future<void> updateTodo(TodoModel todo) async {
    await _todoBox.put(todo.id, todo);
  }

  @override
  Future<void> deleteTodo(String id) async {
    await _todoBox.delete(id);
  }

  @override
  Stream<List<TodoModel>> watchTodos() {
    return _todoBox.watch().map((_) => _todoBox.values.toList());
  }
}