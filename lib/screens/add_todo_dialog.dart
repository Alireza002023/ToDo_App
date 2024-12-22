import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/riverpod/riverpod_todo_list.dart';

class AddTodoDialog extends ConsumerStatefulWidget {
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
    return AlertDialog(
      title: const Text('Add Todo'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(hintText: 'Enter name'),
            ),
            TextField(
              controller: _taskController,
              decoration: InputDecoration(hintText: 'Enter task description'),
            ),
            ListTile(
              title: Text(_selectedDate == null
                  ? 'Select date'
                  : 'Date: ${_selectedDate!.toLocal()}'.split(' ')[0]),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != _selectedDate)
                  setState(() {
                    _selectedDate = picked;
                  });
              },
            ),
            DropdownButton<WorkType>(
              hint: Text('Select work type'),
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
