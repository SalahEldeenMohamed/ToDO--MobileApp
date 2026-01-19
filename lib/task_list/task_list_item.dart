import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/firebase_utils.dart';

import '../edit_task_screen.dart';
import '../model/task.dart';
import '../providers/auth_user_provider.dart';
import '../providers/list_provider.dart';

class TaskListItem extends StatelessWidget {
  final Task task;

  const TaskListItem({required this.task, super.key});

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthUserProvider>(context);
    return Consumer<ListProvider>(
      builder: (context, listProvider, _) {
        // Always get the latest task from Provider
        Task currentTask = listProvider.tasksList
            .firstWhere((t) => t.id == task.id, orElse: () => task);

        return Container(
          margin: const EdgeInsets.all(12),
          child: Slidable(
            startActionPane: ActionPane(
              extentRatio: 0.25,
              motion: const DrawerMotion(),
              children: [
                // DELETE
                SlidableAction(
                  borderRadius: BorderRadius.circular(15),
                  onPressed: (context) async {
                    await FirebaseUtils.deleteTaskFromFireStore(
                        currentTask, authProvider.currentUser!.id!)
                        .then((value) {
                      Fluttertoast.showToast(
                          msg: "Task deleted successfully",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                      print('Task deleted successfully');
                      listProvider.getAllTasksFromFireStore(
                          authProvider.currentUser!.id!);
                    }).timeout(Duration(seconds: 1), onTimeout: () {
                      print('Task deleted successfully');
                      listProvider.getAllTasksFromFireStore(authProvider
                          .currentUser!.id!);
                    });
                    listProvider.getAllTasksFromFireStore(
                        authProvider.currentUser!.id!);
                  },
                  backgroundColor: AppColors.redColor,
                  foregroundColor: AppColors.whiteColor,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
                // EDIT
                SlidableAction(
                  borderRadius: BorderRadius.circular(15),
                  onPressed: (context) async {
                    Task? updatedTask = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditTaskScreen(task: currentTask),
                      ),
                    );

                    if (updatedTask != null) {
                      // Replace the task in Provider
                      listProvider.updateTaskInList(updatedTask);
                    }
                  },
                  backgroundColor: AppColors.grayColor,
                  foregroundColor: AppColors.whiteColor,
                  icon: Icons.edit_note,
                  label: 'Edit',
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left color bar
                  Container(
                    margin: const EdgeInsets.all(12),
                    color: currentTask.isDone
                        ? AppColors.greenColor
                        : AppColors.primaryColor,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.09,
                    width: 4,
                  ),
                  // Task info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          currentTask.title,
                          style: Theme
                              .of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                            color: currentTask.isDone
                                ? Colors.green
                                : AppColors.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          currentTask.description,
                          style: Theme
                              .of(context)
                              .textTheme
                              .titleMedium,
                        ),
                      ],
                    ),
                  ),
                  // Mark done button
                  InkWell(
                    onTap: currentTask.isDone
                        ? null
                        : () => listProvider.markTaskDone(currentTask),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQuery
                            .of(context)
                            .size
                            .height * 0.01,
                        horizontal: MediaQuery
                            .of(context)
                            .size
                            .width * 0.05,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: currentTask.isDone
                            ? AppColors.greenColor
                            : AppColors.primaryColor,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
