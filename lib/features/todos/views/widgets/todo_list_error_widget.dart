import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo/features/todos/providers/todos_provider.dart';

class TodoListErrorWidget extends ConsumerWidget {
  const TodoListErrorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Failed to load todos'),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            // we can use the refresh method for retry
            onPressed: () => ref.read(todosProvider.notifier).refresh(),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
