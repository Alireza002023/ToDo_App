
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart';
import '../services/database_service.dart';

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});

final todosProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  final databaseService = ref.watch(databaseServiceProvider);
  return TodoNotifier(databaseService);
});

class TodoNotifier extends StateNotifier<List<Todo>> {
  final DatabaseService _databaseService;

  TodoNotifier(this._databaseService) : super([]) {
    loadTodos();
  }

  Future<void> loadTodos() async {
    try {
      final todos = await _databaseService.getTodos();
      state = todos;
    } catch (e) {
      print('Error loading todos: $e');
      state = [];
    }
  }

  Future<void> addTodo(String title, String description, DateTime dueDate) async {
    try {
      final todo = Todo(
        title: title,
        description: description,
        dueDate: dueDate,
      );
      final id = await _databaseService.insertTodo(todo);
      final newTodo = Todo(
        id: id,
        title: title,
        description: description,
        dueDate: dueDate,
      );
      state = [...state, newTodo];
    } catch (e) {
      print('Error adding todo: $e');
    }
  }

  Future<void> updateTodo(Todo todo) async {
    try {
      await _databaseService.updateTodo(todo);
      state = [
        for (final item in state)
          if (item.id == todo.id) todo else item
      ];
    } catch (e) {
      print('Error updating todo: $e');
    }
  }

  Future<void> toggleTodo(Todo todo) async {
    try {
      final updatedTodo = Todo(
        id: todo.id,
        title: todo.title,
        description: todo.description,
        dueDate: todo.dueDate,
        isCompleted: !todo.isCompleted,
      );
      await _databaseService.updateTodo(updatedTodo);
      state = [
        for (final item in state)
          if (item.id == todo.id) updatedTodo else item
      ];
    } catch (e) {
      print('Error toggling todo: $e');
    }
  }

  Future<void> deleteTodo(int id) async {
    try {
      await _databaseService.deleteTodo(id);
      state = state.where((todo) => todo.id != id).toList();
    } catch (e) {
      print('Error deleting todo: $e');
    }
  }
}