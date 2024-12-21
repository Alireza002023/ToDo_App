import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TodoListScreen(),
    );
  }
}

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

class TodoListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoList = ref.watch(todoListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: ListView(
        children: [
          for (final todo in todoList)
            ListTile(
              title: Text(todo.description),
              leading: Checkbox(
                value: todo.completed,
                onChanged: (value) {
                  ref.read(todoListProvider.notifier).toggle(todo.id);
                },
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  ref.read(todoListProvider.notifier).remove(todo.id);
                },
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AddTodoDialog();
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddTodoDialog extends ConsumerStatefulWidget {
  @override
  _AddTodoDialogState createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends ConsumerState<AddTodoDialog> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Todo'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(hintText: 'Enter todo description'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            ref.read(todoListProvider.notifier).add(_controller.text);
            Navigator.of(context).pop();
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}