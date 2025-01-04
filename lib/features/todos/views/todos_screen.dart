import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo/features/todos/providers/todos_provider.dart';
import 'package:riverpod_todo/features/todos/views/widgets/add_todo_dialog.dart';

class TodosScreen extends ConsumerWidget {
  const TodosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the todos provider
    final todos = ref.watch(todosProvider);
    final currentFilter = ref.watch(todosProvider.notifier).currentFilter;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
        actions: [
         PopupMenuButton<TodosFilter>(
           icon: const Icon(Icons.filter_list),

           // We are mapping over the TodosFilter enum and creating 
           // a PopupMenuItem for each filter
           itemBuilder: (context) => TodosFilter.values.map((filter) {
             return PopupMenuItem(
               value: filter,
               child: Text(
                 filter.name.toUpperCase(),
                 style: TextStyle(
                   color: currentFilter == filter
                       ? Theme.of(context).colorScheme.primary
                       : Theme.of(context).colorScheme.onSurface,
                 ),
               ),
             );
           }).toList(),
           onSelected: (filter) {
              // Set the current filter to the selected filter
              ref.read(todosProvider.notifier).setFilter(filter);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(todosProvider.notifier).refresh(),
        child: todos.when(
         loading: () => const Center(child: CircularProgressIndicator()),
         error: (error, stackTrace) => Center(
           child: Text('Error: ${error.toString()}'),
         ),
         data: (filteredTodos) => ListView.builder(
           itemCount: filteredTodos.length,
           itemBuilder: (context, index) {
             final todo = filteredTodos[index];
             return ListTile(
               leading: Checkbox(
                 value: todo.completed,
                 onChanged: (_) {
                   ref.read(todosProvider.notifier).toggleTodo(todo.id);
                 },
               ),
               title: Text(
                 todo.title,
                 style: TextStyle(
                   decoration: todo.completed ? TextDecoration.lineThrough : null,
                 ),
               ),
               trailing: IconButton(
                 onPressed: () {
                   ref.read(todosProvider.notifier).removeTodo(todo.id);
                 },
                 icon: const Icon(Icons.delete_outline),
               ),
             );
           },
         ),
             ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddTodoDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
