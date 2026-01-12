import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../firebase_utils.dart';
import '../model/task.dart';

class ListProvider extends ChangeNotifier {
  /// data
  List<Task> tasksList = [];

  void getAllTasksFromFireStore() async {
    /// collection => document => data
    QuerySnapshot<Task> querySnapshot = await FirebaseUtils.getTasksCollection()
        .get();

    /// List<QueryDocumentSnapshot<Task>> => List<Task>
    tasksList = querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();
    notifyListeners();
  }
}
