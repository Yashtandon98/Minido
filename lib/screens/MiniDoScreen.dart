import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Minido/helpers/DatabaseHelper.dart';
import 'package:Minido/models/TaskModel.dart';
import 'package:Minido/screens/AddTaskScreen.dart';

class MiniDoScreen extends StatefulWidget {
  @override
  _MiniDoScreenState createState() => _MiniDoScreenState();
}

class _MiniDoScreenState extends State<MiniDoScreen> {

  Future<List<Task>> _taskList;
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  @override
  void initState(){
    super.initState();
    _updateTaskList();
  }

  _updateTaskList(){
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList();
    });
  }

  Widget _buildTask(Task task){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: [
          ListTile(
            title: Text(task.title, style: TextStyle(fontSize: 18.0, decoration: task.status == 0 ? TextDecoration.none : TextDecoration.lineThrough)),
            subtitle: Text('${_dateFormatter.format(task.date)} | ${task.priority}',
                style: TextStyle(fontSize: 15.0, decoration: task.status == 0 ? TextDecoration.none : TextDecoration.lineThrough
              ),
            ),
            trailing: Checkbox(
                onChanged: (value){
                  task.status = value ? 1 : 0;
                  DatabaseHelper.instance.updateTask(task);
                  _updateTaskList();
              },
            activeColor: Theme.of(context).primaryColor,
            value: task.status == 1 ? true : false,
            ),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>
                AddTaskScreen(
                  UpdateTaskList: _updateTaskList,
                  task: task,
                ),
              ),
            ),
          ),
          Divider(color: Theme.of(context).primaryColor,)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddTaskScreen(UpdateTaskList: _updateTaskList,),
          ),
        ),
      ),
      body: FutureBuilder(
        future: _taskList,
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final int completedTaskCount = snapshot.data
              .where((Task task) => task.status == 1)
              .toList()
              .length;

        return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 80.0),
          itemCount: 1 + snapshot.data.length,
          itemBuilder: (BuildContext context, int index){
            if(index == 0){
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("My Tasks",
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),),
                    SizedBox(height: 10,),
                    Text("$completedTaskCount of ${snapshot.data.length}",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),),
                  ],
                ),
              );
            }
            return _buildTask(snapshot.data[index-1]);
          }
        );
        },
      ),
    );
  }
}
