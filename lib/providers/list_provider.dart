import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../firebase_utils.dart';
import '../model/task.dart';

class ListProvider extends ChangeNotifier {
  /// data
  List<Task> tasksList = [];
  DateTime selectDate = DateTime.now();

  void getAllTasksFromFireStore() async {
    /// collection => document => data
    QuerySnapshot<Task> querySnapshot = await FirebaseUtils.getTasksCollection()
        .get();

    /// List<QueryDocumentSnapshot<Task>> => List<Task>
    tasksList = querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();

    /// filter all tasks => select date
    /// 12/1/2026
    tasksList = tasksList.where((task) {
      if (selectDate.day == task.dateTime.day &&
          selectDate.month == task.dateTime.month &&
          selectDate.year == task.dateTime.year) {
        return true;
      }
      return false;
    }).toList();

    /// sorting tasks
    tasksList.sort((Task task1, Task task2) {
      return task1.dateTime.compareTo(task2.dateTime);
    });

    notifyListeners();
  }

  void changeSelectDate(DateTime newSelectDate) {
    selectDate = newSelectDate;
    getAllTasksFromFireStore();

    /// getAllTasksFromFireStore has notifyListeners so
    /// i don't need to add notifyListeners again here
  }

  void markTaskDone(Task task) {
    task.isDone = true;
    notifyListeners(); // 🚀 INSTANT UI UPDATE
    FirebaseUtils.updateTask(task); // background save
  }

  void updateTaskInList(Task updatedTask) {
    int index = tasksList.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      tasksList[index] = updatedTask;
      notifyListeners(); // rebuild UI instantly
    }
  }
}
