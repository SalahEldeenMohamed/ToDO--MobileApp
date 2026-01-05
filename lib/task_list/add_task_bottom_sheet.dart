import 'package:flutter/material.dart';
import 'package:todo_app/app_colors.dart';

class AddTaskBottomSheet extends StatefulWidget {
  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  var formKey = GlobalKey<FormState>();
  var selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
              'Add new task',
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
                      return 'Please enter task title';
                    }
                    return null;
                  },
                  decoration: InputDecoration(hintText: 'Enter Task Title'),
                ),
                SizedBox(height: 18),
                TextFormField(
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Please enter task Description';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter Task Description',
                  ),
                  maxLines: 4,
                ),
                SizedBox(height: 18),
                Text(
                  'Select Date',
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
                    'Add',
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
