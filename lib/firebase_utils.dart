import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/model/my_user.dart';
import 'package:todo_app/model/task.dart';

class FirebaseUtils {
  // static CollectionReference<Task> getTasksCollection() {
  //   return FirebaseFirestore.instance
  //       .collection(Task.collectionName)
  //       .withConverter<Task>(
  //         fromFirestore: (snapshot, options) =>
  //             Task.fromFireStore(snapshot.data()!),
  //         toFirestore: (task, options) => task.toFireStore(),
  //       );
  // }
  static CollectionReference<Task> getTasksCollection(String uId) {
    return getUsersCollection().doc(uId)
        .collection(Task.collectionName)
        .withConverter<Task>(
          fromFirestore: (snapshot, _) {
            Task task = Task.fromFireStore(snapshot.data()!);
            task.id = snapshot.id; // 🔥 VERY IMPORTANT
            return task;
          },
          toFirestore: (task, _) => task.toFireStore(),
        );
  }

  static Future<void> addTaskToFireStore(Task task, String uId) {
    var taskCollection = getTasksCollection(uId);
    DocumentReference<Task> taskDocRef = taskCollection.doc();
    task.id = taskDocRef.id;
    return taskDocRef.set(task);
  }

  static Future<void> deleteTaskFromFireStore(Task task, String uId) {
    return getTasksCollection(uId).doc(task.id).delete();
  }

  static Future<void> updateTask(Task task) {
    return FirebaseFirestore.instance
        .collection(Task.collectionName)
        .doc(task.id) // 🔥 very important
        .update(task.toFireStore());
  }

  static CollectionReference<MyUser> getUsersCollection() {
    return FirebaseFirestore.instance.collection(MyUser.collectionName).
    withConverter<MyUser>(
        fromFirestore: ((snapshot, options) =>
            MyUser.fromFireStore(snapshot.data())),
        toFirestore: (myUser, options) => myUser.toFireStore()
    );
  }

  static Future<void> addUserToFireStore(MyUser myUser) {
    return getUsersCollection().doc(myUser.id).set(myUser);
  }

  /// when function is async so we must make the return type Future
  static Future<MyUser?> readUserFromFireStore(String uid) async {
    var querySnapshot = await getUsersCollection().doc(uid).get();
    return querySnapshot.data();
  }
}
