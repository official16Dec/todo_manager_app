import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final Function() onToggle;
  final Function() onDelete;
  final Function() onTap;

  const TodoItem({
    Key? key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (value) => onToggle(),
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            color: todo.isCompleted ? Colors.grey : null,
          ),
        ),
        subtitle: todo.description.isNotEmpty
            ? Text(
          todo.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            color: todo.isCompleted ? Colors.grey : null,
          ),
        )
            : null,
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
        onTap: onTap,
      ),
    );
  }
}