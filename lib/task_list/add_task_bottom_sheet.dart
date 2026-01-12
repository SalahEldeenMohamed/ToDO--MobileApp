import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/firebase_utils.dart';

import '../l10n/app_localizations.dart';
import '../model/task.dart';
import '../providers/list_provider.dart';

class AddTaskBottomSheet extends StatefulWidget {
  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  var formKey = GlobalKey<FormState>();
  var selectedDate = DateTime.now();
  String title = '';
  String description = '';
  late ListProvider listProvider;

  @override
  Widget build(BuildContext context) {
    listProvider = Provider.of<ListProvider>(context);
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
              AppLocalizations.of(context)!.addTaskTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return AppLocalizations.of(context)!.taskWarning;
                    }
                    return null;
                  },
                  onChanged: (text) {
                    title = text;
                  },
                  decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.enterTask),
                ),
                SizedBox(height: 18),
                TextFormField(
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return AppLocalizations.of(context)!.descWarning;
                    }
                    return null;
                  },
                  onChanged: (text) {
                    description = text;
                  },
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.enterDesc,
                  ),
                  maxLines: 4,
                ),
                SizedBox(height: 18),
                Text(
                  AppLocalizations.of(context)!.selectTime,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    showCalendar();
                  },
                  child: Text(
                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 18),
                ElevatedButton(
                  onPressed: () {
                    addTask();
                  },
                  child: Text(
                    AppLocalizations.of(context)!.addText,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void addTask() {
    if (formKey.currentState?.validate() == true) {
      /// add task
      Task task = Task(
          title: title,
          description: description,
          dateTime: selectedDate
      );
      FirebaseUtils.addTaskToFireStore(task).timeout(Duration(seconds: 2),
          onTimeout: () {
            print('task added successfully');
            listProvider.getAllTasksFromFireStore();
            Navigator.pop(context);
          }
      );
    }
  }

  void showCalendar() async {
    var chosenDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (chosenDate != null) {
      selectedDate = chosenDate;
      setState(() {});
    }
  }
}
