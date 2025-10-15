import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/todo_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // Method to generate themes (not const)
  Map<String, ThemeData> _getThemes() {
    return {
      'light': ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      'dark': ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      'green': ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.light,
      ),
      'purple': ThemeData(
        primarySwatch: Colors.purple,
        brightness: Brightness.dark,
      ),
      'orange': ThemeData(
        primarySwatch: Colors.orange,
        brightness: Brightness.light,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodoProvider(),
      child: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          final themes = _getThemes();

          return MaterialApp(
            title: 'Todo App',
            theme: themes[todoProvider.currentTheme] ?? themes['light']!,
            home: const HomeScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}