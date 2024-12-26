
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';

class TodoFormScreen extends ConsumerStatefulWidget {
  final Todo? todo;

  const TodoFormScreen({Key? key, this.todo}) : super(key: key);

  @override
  _TodoFormScreenState createState() => _TodoFormScreenState();
}

class _TodoFormScreenState extends ConsumerState<TodoFormScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      _titleController.text = widget.todo!.title;
      _descriptionController.text = widget.todo!.description;
      _selectedDate = widget.todo!.dueDate;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveTodo() async {
    if (_titleController.text.isEmpty) return;

    try {
      if (widget.todo == null) {
        // Add new todo
        await ref.read(todosProvider.notifier).addTodo(
              _titleController.text,
              _descriptionController.text,
              _selectedDate,
            );
      } else {
        // Update existing todo
        final updatedTodo = Todo(
          id: widget.todo!.id,
          title: _titleController.text,
          description: _descriptionController.text,
          dueDate: _selectedDate,
          isCompleted: widget.todo!.isCompleted,
        );
        await ref.read(todosProvider.notifier).updateTodo(updatedTodo);
      }

      // After successful save, refresh the todos list
      await ref.read(todosProvider.notifier).loadTodos();
      
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطا در ذخیره‌سازی تسک')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todo == null ? 'افزودن تسک جدید' : 'ویرایش تسک'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'عنوان',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'توضیحات',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text('تاریخ: ${_selectedDate.toLocal().toString().split(' ')[0]}'),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _selectDate,
                  child: Text('انتخاب تاریخ'),
                ),
              ],
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveTodo,
              child: Text(widget.todo == null ? 'افزودن' : 'به‌روزرسانی'),
            ),
          ],
        ),
      ),
    );
  }
}