import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/todo.dart';

class TodoCarousel extends StatelessWidget {
  final List<Todo> todos;

  const TodoCarousel({Key? key, required this.todos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (todos.isEmpty) {
      return const Center(
        child: Text('No todos available'),
      );
    }

    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: false,
        autoPlay: false,
        enlargeCenterPage: true,
      ),
      items: todos.map((todo) {
        return Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todo.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                if (todo.description.isNotEmpty)
                  Text(
                    todo.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                const Spacer(),
                Row(
                  children: [
                    Chip(
                      label: Text(todo.category),
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                    ),
                    const Spacer(),
                    Text(
                      '${todo.createdAt.day}/${todo.createdAt.month}/${todo.createdAt.year}',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}