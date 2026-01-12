import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/firebase_utils.dart';

import '../model/task.dart';
import '../providers/list_provider.dart';

class TaskListItem extends StatelessWidget {
  Task task;

  TaskListItem({required this.task});

  @override
  Widget build(BuildContext context) {
    var listProvider = Provider.of<ListProvider>(context);
    return Container(
      margin: EdgeInsets.all(12),
      child: Slidable(
        // The start action pane is the one at the left or the top side.
        startActionPane: ActionPane(
          extentRatio: 0.25,
          // A motion is a widget used to control how the pane animates.
          motion: const DrawerMotion(),

          // All actions are defined in the children parameter.
          children: [
            // A SlidableAction can have an icon and/or a label.
            SlidableAction(
              borderRadius: BorderRadius.circular(15),
              onPressed: (context) {
                /// delete task
                FirebaseUtils.deleteTaskFromFireStore(task).timeout(
                    Duration(seconds: 1),
                    onTimeout: () {
                      listProvider.getAllTasksFromFireStore();
                      print('task deleted sucessfully');
                    }
                );
              },
              backgroundColor: AppColors.redColor,
              foregroundColor: AppColors.whiteColor,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.all(12),
                color: task.isDone ? AppColors.greenColor : AppColors
                    .primaryColor,
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.09,
                width: 4,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      task.title,
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                        color: task.isDone ? Colors.green : AppColors
                            .primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      task.description,
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleMedium,
                    ),
                  ],
                ),
              ),
              // if (!task.isDone)
              //   InkWell(
              //     onTap: () async {
              //       task.isDone = true;
              //
              //       await FirebaseUtils.updateTask(task);
              //
              //       Provider.of<ListProvider>(context, listen: true)
              //           .getAllTasksFromFireStore();
              //     },
              //     child: Container(
              //       padding: EdgeInsets.symmetric(
              //         vertical: MediaQuery.of(context).size.height * 0.01,
              //         horizontal: MediaQuery.of(context).size.width * 0.05,
              //       ),
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(12),
              //         color: AppColors.primaryColor,
              //       ),
              //       child: const Icon(
              //         Icons.check,
              //         color: Colors.white,
              //         size: 35,
              //       ),
              //     ),
              //   ),
              InkWell(
                onTap: task.isDone
                    ? null // ❌ disables click
                    : () {
                  Provider.of<ListProvider>(context, listen: false)
                      .markTaskDone(task);
                },
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
                    color: task.isDone
                        ? AppColors.greenColor // ✅ done color
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
  }
}
