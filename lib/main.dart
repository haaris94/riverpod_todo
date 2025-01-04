import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_todo/data/models/todo.dart';
import 'package:riverpod_todo/features/todos/views/todos_screen.dart';

// Make the main function async
void main() async {
  // Ensure WidgetsFlutterBinding is initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register the Todo adapter
  Hive.registerAdapter(TodoAdapter());

  // Run the app
  runApp(
    const ProviderScope(
      child: TodosApp(),
    ),
  );
}

class TodosApp extends StatelessWidget {
  const TodosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todos App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.purple[50],
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.grey[900],
      ),
      home: const TodosScreen(),
    );
  }
}
