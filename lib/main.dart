import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/screen/tasks_screen.dart';
import 'package:todo_app/viewmodel/tasks_view_model.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TaskScreen(),
      ),
    );
  }
}
