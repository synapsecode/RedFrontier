class UserTodo {
  final String id;
  final String taskName;
  final DateTime taskStartDate;
  final DateTime taskEndDate;
  final bool complete;

  UserTodo({
    required this.id,
    required this.taskName,
    required this.taskStartDate,
    required this.taskEndDate,
    required this.complete,
  });
}
