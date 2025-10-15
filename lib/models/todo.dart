class Todo {
  int? id;
  String title;
  String description;
  bool isCompleted;
  DateTime createdAt;
  DateTime? completedAt;
  String category;
  String? imageUrl;

  Todo({
    this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    required this.createdAt,
    this.completedAt,
    this.category = 'Personal',
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'completedAt': completedAt?.millisecondsSinceEpoch,
      'category': category,
      'imageUrl': imageUrl,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'] == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      completedAt: map['completedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['completedAt'])
          : null,
      category: map['category'],
      imageUrl: map['imageUrl'],
    );
  }

  Todo copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? completedAt,
    String? category,
    String? imageUrl,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}