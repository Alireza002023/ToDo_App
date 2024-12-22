import 'package:flutter_riverpod/flutter_riverpod.dart';


enum WorkType { travel, work, playing, fun }

class Todo {
  final String id;
  final String name;
  final String description;
  final DateTime date;
  final WorkType workType;
  final bool completed;

  Todo({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.workType,
    this.completed = false,
  });
}

class TodoList extends StateNotifier<List<Todo>> {
  TodoList() : super([]); // the complete list of todos is empty initially but can be added later.

  void add(String name, String description, DateTime date, WorkType workType) {
    state = [
      ...state,
      Todo(
        id: DateTime.now().toString(),
        name: name,
        description: description,
        date: date,
        workType: workType,
      ),
    ];
  }

  void toggle(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
            id: todo.id,
            name: todo.name,
            description: todo.description,
            date: todo.date,
            workType: todo.workType,
            completed: !todo.completed,
          )
        else
          todo,
    ];
  }

  void remove(String id) {
    state = state.where((todo) => todo.id != id).toList();
  }
}

final todoListProvider = StateNotifierProvider<TodoList, List<Todo>>((ref) {
  return TodoList();
});
