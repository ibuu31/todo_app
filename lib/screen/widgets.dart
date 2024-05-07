import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/constants/constants.dart';
import 'package:todo_app/model/task_model.dart';
import 'package:todo_app/viewmodel/tasks_view_model.dart';

class TaskWidget extends StatelessWidget {
  const TaskWidget({super.key, required this.task});
  final Task task;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      leading: Checkbox(
          onChanged: (value) {
            Provider.of<TaskViewModel>(context, listen: false)
                .taskCompleted(task, task.taskName);
          },
          value: false),
      title: Text(
        task.taskName,
        style: const TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        "${task.date}, ${task.time}",
        style: const TextStyle(color: textBlue),
      ),
    );
  }
}

class CompletedTaskWidget extends StatelessWidget {
  const CompletedTaskWidget({super.key, required this.task});
  final CompletedTask task;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      title: Text(
        task.taskName,
        style: const TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class CustomFAB extends StatelessWidget {
  const CustomFAB({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return const CustomDialog();
          },
        );
      },
      child: const Icon(
        Icons.add,
        size: 40,
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double sh = MediaQuery.sizeOf(context).height;
    double sw = MediaQuery.sizeOf(context).width;
    final taskProvider = Provider.of<TaskViewModel>(context, listen: false);
    return Dialog(
      backgroundColor: secondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
      child: SizedBox(
        height: sh * 0.5,
        width: sw * 0.8,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: sw * 0.05, vertical: sh * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "New Task",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "What has to be done?",
                style: TextStyle(color: textBlue),
              ),
              CustomTextfield(
                hint: "Enter a Task",
                onChanged: (value) {
                  taskProvider.setTaskName(value);
                },
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                "Due Date",
                style: TextStyle(color: textBlue),
              ),
              CustomTextfield(
                hint: "Enter a Date",
                readOnly: true,
                icon: Icons.calendar_month,
                controller: taskProvider.dateCont,
                onTap: () async {
                  DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2017),
                      lastDate: DateTime(2030));

                  taskProvider.setDate(date);
                },
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextfield(
                hint: "Enter a Time",
                readOnly: true,
                icon: Icons.timer,
                controller: taskProvider.timeCont,
                onTap: () async {
                  TimeOfDay? time = await showTimePicker(
                      context: context, initialTime: TimeOfDay.now());

                  taskProvider.setTime(time);
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: () async {
                      Task task = Task(
                          taskProvider.taskName ?? "",
                          taskProvider.dateCont.text,
                          taskProvider.timeCont.text);
                      await taskProvider.insertTodo(task);

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                      await taskProvider.getTodos(1);
                    },
                    child: const Text(
                      "Create",
                      style: TextStyle(color: primary),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextfield extends StatelessWidget {
  const CustomTextfield(
      {super.key,
      required this.hint,
      this.icon,
      this.onTap,
      this.readOnly = false,
      this.onChanged,
      this.controller});

  final String hint;
  final IconData? icon;
  final void Function()? onTap;
  final bool readOnly;
  final void Function(String)? onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: TextField(
        readOnly: readOnly,
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
            suffixIcon: InkWell(
                onTap: onTap,
                child: Icon(
                  icon,
                  color: Colors.white,
                )),
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey)),
      ),
    );
  }
}
