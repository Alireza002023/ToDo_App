import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:todo_app/models/todo.dart";

class TodoList extends StateNotifier<List<Todo>> {
  TodoList() : super([]);

  void add(String description) {
    state = [
      ...state,
      Todo(
        id: DateTime.now().toString(),
        description: description,
      ),
    ];
  }

  void toggle(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
            id: todo.id,
            description: todo.description,
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