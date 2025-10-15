import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';
import '../widgets/todo_item.dart';
import '../widgets/add_todo_dialog.dart';
import '../widgets/theme_switcher.dart';
import '../widgets/todo_carousel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  void _showAddTodoDialog() {
    showDialog(
      context: context,
      builder: (context) => AddTodoDialog(
        onAdd: (todo) {
          Provider.of<TodoProvider>(context, listen: false).addTodo(todo);
        },
      ),
    );
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final todoProvider = Provider.of<TodoProvider>(context);
        return AlertDialog(
          title: const Text('Choose Theme'),
          content: ThemeSwitcher(
            currentTheme: todoProvider.currentTheme,
            onThemeChanged: (theme) {
              todoProvider.changeTheme(theme);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _onRefresh() async {
    await Provider.of<TodoProvider>(context, listen: false).refreshTodos();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.color_lens),
            onPressed: _showThemeDialog,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          return SmartRefresher(
            controller: _refreshController,
            onRefresh: _onRefresh,
            child: TabBarView(
              controller: _tabController,
              children: [
                // All Todos Tab
                _buildTodoList(todoProvider.todos, todoProvider),

                // Pending Todos Tab
                _buildTodoList(todoProvider.pendingTodos, todoProvider),

                // Completed Todos Tab
                _buildTodoList(todoProvider.completedTodos, todoProvider),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTodoList(List<Todo> todos, TodoProvider todoProvider) {
    if (todos.isEmpty) {
      return const Center(
        child: Text(
          'No todos found',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return Column(
      children: [
        // Carousel for featured todos
        if (todos.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Featured Todos',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          TodoCarousel(todos: todos.take(5).toList()),
          const SizedBox(height: 16),
        ],

        // List of todos
        Expanded(
          child: ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return TodoItem(
                todo: todo,
                onToggle: () => todoProvider.toggleTodoCompletion(todo.id!),
                onDelete: () => todoProvider.deleteTodo(todo.id!),
                onTap: () {
                  // Show todo details
                  _showTodoDetails(todo, todoProvider);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _showTodoDetails(Todo todo, TodoProvider todoProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(todo.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (todo.description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(todo.description),
                ),
              Chip(
                label: Text(todo.category),
              ),
              const SizedBox(height: 16),
              Text('Created: ${_formatDate(todo.createdAt)}'),
              if (todo.completedAt != null)
                Text('Completed: ${_formatDate(todo.completedAt!)}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              todoProvider.toggleTodoCompletion(todo.id!);
              Navigator.of(context).pop();
            },
            child: Text(todo.isCompleted ? 'Mark Pending' : 'Mark Complete'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}