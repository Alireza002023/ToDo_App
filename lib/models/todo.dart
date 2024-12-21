class Todo {
  final String id;
  final String description;
  final bool completed;

  Todo({
    required this.id,
    required this.description,
    this.completed = false,
  });
}