
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/todo_screen.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'برنامه تسک',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Vazir', // اگر می‌خواهید از فونت فارسی استفاده کنید
      ),
      home: TodoScreen(),
    );
  }
}