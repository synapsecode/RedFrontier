import 'package:flutter/material.dart';
import 'package:redfrontier/extensions/extensions.dart';
import 'package:redfrontier/main.dart';
import 'package:redfrontier/models/redfrontier_user.dart';
import 'package:redfrontier/models/reports.dart';
import 'package:redfrontier/models/user_todo.dart';
import 'package:redfrontier/services/firestore/reports.dart';
import 'package:redfrontier/services/firestore/tasks.dart';

class TasksListPage extends StatelessWidget {
  const TasksListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = gpc.read(currentRFUserProvider)!.id;
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Tasks'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Create Task'),
                content: EnterTaskDetails(uid: uid),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: FirestoreTasks.userTodosAsStream(uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Text('No Tasks for now').color(Colors.white).center();
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return TaskElement(model: snapshot.data![index]);
              },
            );
          }
          return Text('Unable to Fetch').color(Colors.white).center();
        },
      ),
    );
  }
}

class TaskElement extends StatelessWidget {
  final UserTodo model;
  const TaskElement({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.red[100],
      title: Text(model.taskName),
      leading: CircleAvatar(
        backgroundColor: model.complete ? Colors.red : Colors.grey,
      ),
      subtitle: Text('Due Date: ${model.taskEndDate}'),
      onTap: () {
        FirestoreTasks.completeTodo(
            gpc.read(currentRFUserProvider)!.id, model.id);
      },
      trailing: Icons.delete.toIcon(color: Colors.red).onClick(() {
        FirestoreTasks.deleteTodo(
            gpc.read(currentRFUserProvider)!.id, model.id);
      }),
    );
  }
}

class EnterTaskDetails extends StatefulWidget {
  final String uid;

  EnterTaskDetails({required this.uid});

  @override
  _EnterTaskDetailsState createState() => _EnterTaskDetailsState();
}

class _EnterTaskDetailsState extends State<EnterTaskDetails> {
  final TextEditingController _taskNameController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 7));

  void _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  void _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  void _createTodo() async {
    final String taskName = _taskNameController.text.trim();
    if (taskName.isNotEmpty) {
      await FirestoreTasks.createTodo(
        widget.uid,
        taskName,
        _startDate,
        _endDate,
      );
      Navigator.pop(context); // Close the EnterTaskDetails screen
    } else {
      // Show an error message or handle empty task name
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _taskNameController,
            decoration: InputDecoration(labelText: 'Task Name'),
          ),
          SizedBox(height: 16.0),
          Wrap(
            children: [
              Text('Start Date: \n${_startDate.toLocal()}'),
              SizedBox(width: 8.0),
              ElevatedButton(
                onPressed: () => _selectStartDate(context),
                child: Text('Select Date'),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Wrap(
            children: [
              Text('End Date:\n ${_endDate.toLocal()}'),
              SizedBox(width: 8.0),
              ElevatedButton(
                onPressed: () => _selectEndDate(context),
                child: Text('Select Date'),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: _createTodo,
            child: Text('Create Todo'),
          ).limitSize(double.infinity),
        ],
      ),
    );
  }
}
