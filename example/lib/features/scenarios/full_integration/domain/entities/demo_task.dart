final class DemoTask {
  const DemoTask({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    required this.priority,
    required this.createdAt,
  });

  final int id;
  final String title;
  final String description;
  final bool completed;
  final String priority;
  final DateTime createdAt;

  factory DemoTask.fromJson(Map<String, dynamic> json) {
    const priorities = ['Low', 'Medium', 'High', 'Urgent'];
    final id = json['id'] as int? ?? 0;
    return DemoTask(
      id: id,
      title: json['title'] as String? ?? 'Task',
      description: json['body'] as String? ?? 'No description',
      completed: json['completed'] as bool? ?? false,
      priority: priorities[(id == 0 ? 1 : id) % priorities.length],
      createdAt: DateTime.now().subtract(
        Duration(days: (id == 0 ? 1 : id) % 30),
      ),
    );
  }

  DemoTask copyWith({bool? completed}) {
    return DemoTask(
      id: id,
      title: title,
      description: description,
      completed: completed ?? this.completed,
      priority: priority,
      createdAt: createdAt,
    );
  }
}
