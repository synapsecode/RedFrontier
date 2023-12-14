import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redfrontier/models/user_todo.dart';

class FirestoreTasks {
  static final CollectionReference<Map<String, dynamic>> _userTodosCollection =
      FirebaseFirestore.instance.collection('user_todos');

  static Stream<List<UserTodo>> userTodosAsStream(String uid) {
    return _userTodosCollection
        .doc(uid)
        .collection('tasks')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return UserTodo(
          id: doc.id,
          taskName: data['task_name'] ?? '',
          taskStartDate: data['task_start_date'].toDate() ?? DateTime.now(),
          taskEndDate: data['task_end_date'].toDate() ?? DateTime.now(),
          complete: data['complete'] ?? false,
        );
      }).toList();
    });
  }

  static Future<void> deleteTodo(String uid, String todoId) {
    return _userTodosCollection
        .doc(uid)
        .collection('tasks')
        .doc(todoId)
        .delete();
  }

  static Future<void> completeTodo(String uid, String todoId) {
    return _userTodosCollection
        .doc(uid)
        .collection('tasks')
        .doc(todoId)
        .update({'complete': true});
  }

  static Future<void> createTodo(
    String uid,
    String name,
    DateTime start,
    DateTime end,
  ) {
    return _userTodosCollection
        .doc(uid)
        .collection('tasks')
        .add({
          'task_name': name,
          'task_start_date': start,
          'task_end_date': end,
          'complete': false,
        })
        .then((value) => print("Todo Added"))
        .catchError(
          (error) => print("Failed to add todo: $error"),
        );
  }
}
