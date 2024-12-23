import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/riverpod/riverpod_todo_list.dart';

class TodoListScreen extends ConsumerWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoList = ref.watch(todoListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: ListView(
        children: [
          for (final todo in todoList)
            ListTile(
              title: Text(
                todo.name,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.normal),
              ),
              subtitle: Text(
                todo.description,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
              ),
              leading: Checkbox(
                value: todo.completed,
                onChanged: (value) {
                  ref.read(todoListProvider.notifier).toggle(todo.id);
                },
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
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
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddTodoDialog extends ConsumerStatefulWidget {
  const AddTodoDialog({super.key});

  @override
  _AddTodoDialogState createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends ConsumerState<AddTodoDialog> {
  final _nameController = TextEditingController();
  final _taskController = TextEditingController();
  DateTime? _selectedDate;
  WorkType? _selectedWorkType;

  @override
  Widget build(BuildContext context) {
    // AlertDialog is a dialog that interrupts the user's workflow to get a response from the user.
    return AlertDialog(
      title: const Text('Add Todo'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _nameController,

              decoration: const InputDecoration(
                  hintText:
                      'Enter name'), // InputDecoration is used to configure the visual appearance of an input field.
            ),
            TextField(
              controller: _taskController,
              decoration:
                  const InputDecoration(hintText: 'Enter task description'),
            ),
            ListTile(
              title: Text(_selectedDate == null
                  ? 'Select date'
                  : 'Date: ${_selectedDate!.toLocal()}'.split(' ')[
                      0]), // toLocal() converts the date to the local time zone and split(' ')[0] is used to get the date only.
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != _selectedDate) {
                  setState(() {
                    _selectedDate = picked;
                  });
                }
              },
            ),
            DropdownButton<WorkType>(
              hint: const Text('Select work type'),
              value: _selectedWorkType,
              onChanged: (WorkType? newValue) {
                setState(() {
                  _selectedWorkType = newValue;
                });
              },
              items: WorkType.values.map((WorkType workType) {
                return DropdownMenuItem<WorkType>(
                  value: workType,
                  child: Text(workType.toString().split('.').last),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty &&
                _taskController.text.isNotEmpty &&
                _selectedDate != null &&
                _selectedWorkType != null) {
              ref.read(todoListProvider.notifier).add(
                    _nameController.text,
                    _taskController.text,
                    _selectedDate!,
                    _selectedWorkType!,
                  );
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
