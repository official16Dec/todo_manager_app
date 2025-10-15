import 'package:flutter/foundation.dart';
import '../models/todo.dart';
import '../services/storage_service.dart';

class TodoProvider with ChangeNotifier {
  List<Todo> _todos = [];
  final StorageService _storageService = StorageService();
  String _currentTheme = 'light';

  List<Todo> get todos => _todos;
  List<Todo> get completedTodos => _todos.where((todo) => todo.isCompleted).toList();
  List<Todo> get pendingTodos => _todos.where((todo) => !todo.isCompleted).toList();
  String get currentTheme => _currentTheme;

  TodoProvider() {
    _loadTodos();
    _loadTheme();
  }

  Future<void> _loadTodos() async {
    _todos = await _storageService.loadTodos();
    notifyListeners();
  }

  Future<void> _loadTheme() async {
    final theme = await _storageService.loadTheme();
    if (theme != null) {
      _currentTheme = theme;
    }
    notifyListeners();
  }

  Future<void> addTodo(Todo todo) async {
    final newTodo = todo.copyWith(
      id: DateTime.now().millisecondsSinceEpoch,
    );
    _todos.add(newTodo);
    await _saveTodos();
    notifyListeners();
  }

  Future<void> updateTodo(Todo updatedTodo) async {
    final index = _todos.indexWhere((todo) => todo.id == updatedTodo.id);
    if (index != -1) {
      _todos[index] = updatedTodo;
      await _saveTodos();
      notifyListeners();
    }
  }

  Future<void> deleteTodo(int id) async {
    _todos.removeWhere((todo) => todo.id == id);
    await _saveTodos();
    notifyListeners();
  }

  Future<void> toggleTodoCompletion(int id) async {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      final todo = _todos[index];
      _todos[index] = todo.copyWith(
        isCompleted: !todo.isCompleted,
        completedAt: !todo.isCompleted ? DateTime.now() : null,
      );
      await _saveTodos();
      notifyListeners();
    }
  }

  Future<void> changeTheme(String themeName) async {
    _currentTheme = themeName;
    await _storageService.saveTheme(themeName);
    notifyListeners();
  }

  Future<void> _saveTodos() async {
    await _storageService.saveTodos(_todos);
  }

  // Pull to refresh functionality
  Future<void> refreshTodos() async {
    await _loadTodos();
  }
}