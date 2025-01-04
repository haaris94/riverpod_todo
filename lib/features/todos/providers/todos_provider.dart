import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_todo/data/models/todo.dart';
import 'package:riverpod_todo/data/repositories/todos_repository.dart';

part 'todos_provider.g.dart';

/// Filter for todos
enum TodosFilter { all, completed, active }

@riverpod
class Todos extends _$Todos {
  late final TodosRepository repository;
  TodosFilter _filter = TodosFilter.all;
  List<Todo> _allTodos = [];

  TodosFilter get currentFilter => _filter;

  @override
  FutureOr<List<Todo>> build() async {
    repository = ref.watch(todosRepositoryProvider);
    // Store the full list
    _allTodos = await repository.getTodos();
    // Return filtered list
    return _getFilteredTodos();
  }

  /// Returns the filtered list of todos
  List<Todo> _getFilteredTodos() {
    switch (_filter) {
      case TodosFilter.completed:
        return _allTodos.where((todo) => todo.completed).toList();
      case TodosFilter.active:
        return _allTodos.where((todo) => !todo.completed).toList();
      case TodosFilter.all:
        return _allTodos;
    }
  }

  void setFilter(TodosFilter filter) {
    _filter = filter;

    // Just update the state with newly filtered list
    state = AsyncValue.data(_getFilteredTodos());
  }

  Future<void> addTodo(String title) async {
    final todo = Todo(
      id: DateTime.now().toIso8601String(),
      title: title,
    );

    // Optimistically update the local state
    _allTodos = [..._allTodos, todo];
    state = AsyncValue.data(_getFilteredTodos());

    state = await AsyncValue.guard(() async {
      await repository.addTodo(todo);
      return _getFilteredTodos();
    });

    if (state.hasError) {
      _allTodos.removeLast();
      state = AsyncValue.data(_getFilteredTodos());
    }
  }

  Future<void> toggleTodo(String id) async {
    // Find and update the todo in local state
    final todoIndex = _allTodos.indexWhere((t) => t.id == id);
    final todo = _allTodos[todoIndex];
    final updatedTodo = todo.copyWith(completed: !todo.completed);

    // Optimistically update the local state
    _allTodos[todoIndex] = updatedTodo;
    state = AsyncValue.data(_getFilteredTodos());

    state = await AsyncValue.guard(() async {
      await repository.updateTodo(updatedTodo);
      return _getFilteredTodos();
    });

    if (state.hasError) {
      // Revert to original state if operation failed
      _allTodos[todoIndex] = todo;
      state = AsyncValue.data(_getFilteredTodos());
    }
  }

  Future<void> removeTodo(String id) async {
    // Find the todo and its index
    final todoIndex = _allTodos.indexWhere((t) => t.id == id);
    final todo = _allTodos[todoIndex];

    // Optimistically update the local state
    _allTodos.removeAt(todoIndex);
    state = AsyncValue.data(_getFilteredTodos());

    state = await AsyncValue.guard(() async {
      await repository.deleteTodo(todo);
      return _getFilteredTodos();
    });

    if (state.hasError) {
      // Revert to original state if operation failed
      _allTodos.insert(todoIndex, todo);
      state = AsyncValue.data(_getFilteredTodos());
    }
  }

  /// Refreshes the todos list from the repository
  Future<void> refresh() async {
    // Keep previous state(data or error) while loading
    state = const AsyncLoading<List<Todo>>().copyWithPrevious(state);

    state = await AsyncValue.guard(() async {
      _allTodos = await repository.getTodos();
      return _getFilteredTodos();
    });
  }

}
