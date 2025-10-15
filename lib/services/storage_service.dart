import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/todo.dart';

class StorageService {
  static const String _todosKey = 'todos';
  static const String _themeKey = 'theme';

  Future<List<Todo>> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? todosJson = prefs.getString(_todosKey);

    if (todosJson == null) return [];

    try {
      final List<dynamic> todosList = json.decode(todosJson);
      return todosList.map((item) => Todo.fromMap(item)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveTodos(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final String todosJson = json.encode(
        todos.map((todo) => todo.toMap()).toList()
    );
    await prefs.setString(_todosKey, todosJson);
  }

  Future<String?> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeKey);
  }

  Future<void> saveTheme(String themeName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, themeName);
  }
}