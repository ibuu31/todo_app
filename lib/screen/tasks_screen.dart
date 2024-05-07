import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/constants/constants.dart';
import 'package:todo_app/screen/widgets.dart';
import 'package:todo_app/viewmodel/tasks_view_model.dart';

class TaskScreen extends StatelessWidget {
  TaskScreen({super.key});

  final List<Widget> _pages = [
    Consumer<TaskViewModel>(builder: (context, taskProvider, _) {
      taskProvider.initDatabase();
      return ListView.separated(
          itemBuilder: (context, index) {
            final task = taskProvider.tasks[index];
            return TaskWidget(
              task: task,
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(
              color: primary,
              height: 1,
              thickness: 1,
            );
          },
          itemCount: taskProvider.tasks.length);
    }),
    Consumer<TaskViewModel>(builder: (context, taskProvider, _) {
      taskProvider.initDatabase2();
      return ListView.separated(
          itemBuilder: (context, index) {
            final task = taskProvider.completedTasks[index];
            return CompletedTaskWidget(
              task: task,
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(
              color: primary,
              height: 1,
              thickness: 1,
            );
          },
          itemCount: taskProvider.completedTasks.length);
    }),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondary,
      bottomNavigationBar: Consumer<TaskViewModel>(
        builder: (context, taskProvider, _) {
          return BottomNavigationBar(
            currentIndex: taskProvider.currentIndex,
            onTap: (index) {
              taskProvider.setPageIndex(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.pending_actions),
                label: 'Todo',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.check_circle),
                label: 'Done',
              ),
            ],
          );
        },
      ),
      appBar: AppBar(
        backgroundColor: primary,
        title: const Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.check,
                size: 20,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "To Do List",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Consumer<TaskViewModel>(builder: (context, taskProvider, _) {
        return _pages[taskProvider.currentIndex];
      }),
      floatingActionButton:
          Consumer<TaskViewModel>(builder: (context, taskProvider, _) {
        return taskProvider.currentIndex == 0 ? const CustomFAB() : Container();
      }),
    );
  }
}
