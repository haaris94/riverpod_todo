import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_todo/data/models/todo.dart';

part 'todos_repository.g.dart';

/// Custom exception for Todo-related errors
class TodoException implements Exception {
  final String message;
  final dynamic error;

  TodoException(this.message, [this.error]);

  @override
  String toString() => 'TodoException: $message${error != null ? ' ($error)' : ''}';
}

/// Repository interface for Todo operations
abstract class TodosRepository {
  /// Retrieves all todos from storage
  ///
  /// Throws [TodoException] if the operation fails
  Future<List<Todo>> getTodos();

  /// Adds a new todo to storage
  ///
  /// Throws [TodoException] if the operation fails
  Future<void> addTodo(Todo todo);

  /// Updates an existing todo in storage
  ///
  /// Throws [TodoException] if the todo doesn't exist or the operation fails
  Future<void> updateTodo(Todo todo);

  /// Deletes a todo from storage
  ///
  /// Throws [TodoException] if the todo doesn't exist or the operation fails
  Future<void> deleteTodo(Todo todo);
}

@Riverpod(keepAlive: true)
TodosRepository todosRepository(Ref ref) => LocalTodosRepository();

/// Implementation of [TodosRepository] using Hive
class LocalTodosRepository implements TodosRepository {
  static const String _boxName = 'todos';

  Future<Box<Todo>> _openBox() async {
    try {
      if (Hive.isBoxOpen(_boxName)) {
        return Hive.box<Todo>(_boxName);
      }

      return await Hive.openBox<Todo>(_boxName);
    } catch (e) {
      throw TodoException('Failed to open todos box', e);
    }
  }

  @override
  Future<List<Todo>> getTodos() async {
    try {
      final box = await _openBox();
      return box.values.toList();
    } catch (e) {
      throw TodoException('Failed to get todos', e);
    }
  }

  @override
  Future<void> addTodo(Todo todo) async {
    try {
      final box = await _openBox();
      await box.put(todo.id, todo);
    } catch (e) {
      throw TodoException('Failed to add todo', e);
    }
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    try {
      final box = await _openBox();
      if (!box.containsKey(todo.id)) {
        throw TodoException('Todo not found');
      }
      await box.put(todo.id, todo);
    } catch (e) {
      throw TodoException('Failed to update todo', e);
    }
  }

  @override
  Future<void> deleteTodo(Todo todo) async {
    try {
      final box = await _openBox();
      if (!box.containsKey(todo.id)) {
        throw TodoException('Todo not found');
      }
      await box.delete(todo.id);
    } catch (e) {
      throw TodoException('Failed to delete todo', e);
    }
  }
}
