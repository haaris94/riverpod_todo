# Riverpod Todo App Tutorial

A demo Todo application built with Flutter and Riverpod, demonstrating real-world state management patterns and best practices. This repository accompanies the comprehensive tutorial series on [Master Riverpod in Flutter](https://devayaan.com/blog/series/riverpod/master-riverpod).

## 🌟 Features

- Complete CRUD operations with optimistic updates
- Local persistence using Hive
- Clean Architecture with Repository pattern
- Advanced error handling and retry logic
- Pull-to-refresh functionality
- Filter todos by status (All, Active, Completed)
- Type-safe state management with code generation

## 🚀 Getting Started

1. Clone the repository

```bash
git clone https://github.com/haaris94/riverpod_todo.git
```

2. Install dependencies

```bash
flutter pub get
```

3. Run code generation

```bash
dart run build_runner build
```

4. Run the app

```bash
flutter run
```

## 📚 Tutorial Series

This repository is part of a comprehensive Riverpod tutorial series:

1. [Part 1: Master Riverpod](https://devayaan.com/blog/series/riverpod/master-riverpod) - Core concepts and fundamentals
2. [Part 2: Building a Todo App](https://devayaan.com/blog/series/riverpod/riverpod-todo-app) - Practical implementation

## 🏗️ Project Structure

```
lib/
├── data/
│   ├── model/
│   │   └── todo.dart
│   └── repositories/
│       └── todos_repository.dart
├── features/
│   └── todos/
│       ├── providers/
│       │   └── todos_provider.dart
│       └── view/
│           └── todos_screen.dart
└── main.dart
```

## 💡 Key Concepts Demonstrated

- Proper state management with `AsyncNotifierProvider`
- Repository pattern implementation
- Error handling and loading states
- Optimistic updates for better UX
- Code organization and architecture
- Type-safe code generation

## ⭐ Support

If you found this tutorial helpful, consider giving it a star! It helps others discover this resource and motivates me to create more educational content.

## 📝 License

This project is licensed under the [MIT License](LICENSE.md) - see the full license text for details. Copyright (c) 2024-present [Ayaan Haaris](https://devayaan.com).
